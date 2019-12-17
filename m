Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E924D1220E0
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbfLQA6r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34798 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbfLQAvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:37 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0003KY-Ck; Tue, 17 Dec 2019 00:51:31 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15G-0005Tv-FS; Tue, 17 Dec 2019 00:51:30 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johan Hovold" <johan@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date:   Tue, 17 Dec 2019 00:46:07 +0000
Message-ID: <lsq.1576543535.819253251@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 033/136] USB: usb-skeleton: fix runtime PM after
 driver unbind
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 5c290a5e42c3387e82de86965784d30e6c5270fd upstream.

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191001084908.2003-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/usb-skeleton.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -75,6 +75,7 @@ static void skel_delete(struct kref *kre
 	struct usb_skel *dev = to_skel_dev(kref);
 
 	usb_free_urb(dev->bulk_in_urb);
+	usb_put_intf(dev->interface);
 	usb_put_dev(dev->udev);
 	kfree(dev->bulk_in_buffer);
 	kfree(dev);
@@ -126,10 +127,7 @@ static int skel_release(struct inode *in
 		return -ENODEV;
 
 	/* allow the device to be autosuspended */
-	mutex_lock(&dev->io_mutex);
-	if (dev->interface)
-		usb_autopm_put_interface(dev->interface);
-	mutex_unlock(&dev->io_mutex);
+	usb_autopm_put_interface(dev->interface);
 
 	/* decrement the count on our device */
 	kref_put(&dev->kref, skel_delete);
@@ -511,7 +509,7 @@ static int skel_probe(struct usb_interfa
 	init_waitqueue_head(&dev->bulk_in_wait);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */

