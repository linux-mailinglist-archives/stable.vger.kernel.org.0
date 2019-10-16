Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE7EDA0F7
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389282AbfJPWRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395047AbfJPVyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:54:43 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A7EA20872;
        Wed, 16 Oct 2019 21:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262882;
        bh=l63bBNW4p4Tbl1QgQ/eNqi8H6ikGirXGH3NJnWmRoSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=snAMcGnNL9c/RWwoJlIF4x8G4p1hZvjd69CWA4CcWBSiH+wpVkfJWsmUM0W4xMmBB
         CkfXDiTciyjvoNyiCU+sdOfPR37omeGaQ12gp+I2Lbh/qRVEaF9q0am0PJ3akomdOu
         VUXYmL9SBt75vz2urpDAreCWcoU1HJyyNLPr0zS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.9 40/92] USB: usb-skeleton: fix runtime PM after driver unbind
Date:   Wed, 16 Oct 2019 14:50:13 -0700
Message-Id: <20191016214831.753628078@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214759.600329427@linuxfoundation.org>
References: <20191016214759.600329427@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 5c290a5e42c3387e82de86965784d30e6c5270fd upstream.

Since commit c2b71462d294 ("USB: core: Fix bug caused by duplicate
interface PM usage counter") USB drivers must always balance their
runtime PM gets and puts, including when the driver has already been
unbound from the interface.

Leaving the interface with a positive PM usage counter would prevent a
later bound driver from suspending the device.

Fixes: c2b71462d294 ("USB: core: Fix bug caused by duplicate interface PM usage counter")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191001084908.2003-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usb-skeleton.c |    8 +++-----
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
@@ -509,7 +507,7 @@ static int skel_probe(struct usb_interfa
 	init_waitqueue_head(&dev->bulk_in_wait);
 
 	dev->udev = usb_get_dev(interface_to_usbdev(interface));
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	/* set up the endpoint information */
 	/* use only the first bulk-in and bulk-out endpoints */


