Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF0F2C91C5
	for <lists+stable@lfdr.de>; Wed,  2 Oct 2019 21:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729062AbfJBTII (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Oct 2019 15:08:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35210 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728866AbfJBTIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Oct 2019 15:08:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-00035D-9B; Wed, 02 Oct 2019 20:08:05 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iFjyn-0003aQ-0m; Wed, 02 Oct 2019 20:08:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Shuah Khan" <skhan@linuxfoundation.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Wed, 02 Oct 2019 20:06:51 +0100
Message-ID: <lsq.1570043211.527106392@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 08/87] usbip: usbip_host: fix BUG: sleeping function
 called from invalid context
In-Reply-To: <lsq.1570043210.379046399@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.75-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.16: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/usbip/stub_dev.c | 65 ++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 22 deletions(-)

--- a/drivers/staging/usbip/stub_dev.c
+++ b/drivers/staging/usbip/stub_dev.c
@@ -342,9 +342,17 @@ static int stub_probe(struct usb_device
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
@@ -359,14 +367,14 @@ static int stub_probe(struct usb_device
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
@@ -375,15 +383,9 @@ static int stub_probe(struct usb_device
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
@@ -393,9 +395,13 @@ static int stub_probe(struct usb_device
 
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
@@ -408,15 +414,16 @@ static int stub_probe(struct usb_device
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
@@ -426,23 +433,24 @@ err_port:
 	usb_put_dev(udev);
 	kthread_stop_put(sdev->ud.eh);
 
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
@@ -474,6 +482,9 @@ static void stub_disconnect(struct usb_d
 
 	dev_set_drvdata(&udev->dev, NULL);
 
+	/* release busid_lock before call to remove device files */
+	put_busid_priv(busid_priv);
+
 	/*
 	 * NOTE: rx/tx threads are invoked for each usb_device.
 	 */
@@ -484,18 +495,27 @@ static void stub_disconnect(struct usb_d
 				  (struct usb_dev_state *) udev);
 	if (rc) {
 		dev_dbg(&udev->dev, "unable to release port\n");
-		goto call_put_busid_priv;
+		return;
 	}
 
 	/* If usb reset is called from event handler */
 	if (busid_priv->sdev->ud.eh == current)
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
@@ -504,6 +524,7 @@ static void stub_disconnect(struct usb_d
 		busid_priv->status = STUB_BUSID_ADDED;
 
 call_put_busid_priv:
+	/* release busid_lock */
 	put_busid_priv(busid_priv);
 }
 

