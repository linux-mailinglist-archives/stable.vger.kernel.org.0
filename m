Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A141378E69
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241017AbhEJN27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:28:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242907AbhEJMoo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:44:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88FB160FF2;
        Mon, 10 May 2021 12:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620650619;
        bh=jBpXhoFQoTkdm7vnKeeyRktif/Yor1Enm4DEBlpLdqQ=;
        h=Subject:To:From:Date:From;
        b=wCnt5ITxwnDko8huitwYUPm2ctZp2FeTqw7fYw2KMpT5X8GKDGNrCDgALhA2M/y+d
         Kv+bCCZcNuH8OLZe19g/5AaBBBGXOBVZYHXzA5KNt1qv988T+MMTBxWfhsUVoMeaQT
         maA6DnlaL9DqHon9woKyYcEOEa4f4cZUFSqPCdFg=
Subject: patch "cdc-wdm: untangle a circular dependency between callback and softint" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 May 2021 14:43:36 +0200
Message-ID: <16206506160140@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    cdc-wdm: untangle a circular dependency between callback and softint

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 18abf874367456540846319574864e6ff32752e2 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Mon, 26 Apr 2021 11:26:22 +0200
Subject: cdc-wdm: untangle a circular dependency between callback and softint

We have a cycle of callbacks scheduling works which submit
URBs with those callbacks. This needs to be blocked, stopped
and unblocked to untangle the circle.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20210426092622.20433-1-oneukum@suse.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 508b1c3f8b73..d1e4a7379beb 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -321,12 +321,23 @@ static void wdm_int_callback(struct urb *urb)
 
 }
 
-static void kill_urbs(struct wdm_device *desc)
+static void poison_urbs(struct wdm_device *desc)
 {
 	/* the order here is essential */
-	usb_kill_urb(desc->command);
-	usb_kill_urb(desc->validity);
-	usb_kill_urb(desc->response);
+	usb_poison_urb(desc->command);
+	usb_poison_urb(desc->validity);
+	usb_poison_urb(desc->response);
+}
+
+static void unpoison_urbs(struct wdm_device *desc)
+{
+	/*
+	 *  the order here is not essential
+	 *  it is symmetrical just to be nice
+	 */
+	usb_unpoison_urb(desc->response);
+	usb_unpoison_urb(desc->validity);
+	usb_unpoison_urb(desc->command);
 }
 
 static void free_urbs(struct wdm_device *desc)
@@ -741,11 +752,12 @@ static int wdm_release(struct inode *inode, struct file *file)
 	if (!desc->count) {
 		if (!test_bit(WDM_DISCONNECTING, &desc->flags)) {
 			dev_dbg(&desc->intf->dev, "wdm_release: cleanup\n");
-			kill_urbs(desc);
+			poison_urbs(desc);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
 			spin_unlock_irq(&desc->iuspin);
 			desc->manage_power(desc->intf, 0);
+			unpoison_urbs(desc);
 		} else {
 			/* must avoid dev_printk here as desc->intf is invalid */
 			pr_debug(KBUILD_MODNAME " %s: device gone - cleaning up\n", __func__);
@@ -1037,9 +1049,9 @@ static void wdm_disconnect(struct usb_interface *intf)
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
+	poison_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
-	kill_urbs(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
 
@@ -1080,9 +1092,10 @@ static int wdm_suspend(struct usb_interface *intf, pm_message_t message)
 		set_bit(WDM_SUSPENDING, &desc->flags);
 		spin_unlock_irq(&desc->iuspin);
 		/* callback submits work - order is essential */
-		kill_urbs(desc);
+		poison_urbs(desc);
 		cancel_work_sync(&desc->rxwork);
 		cancel_work_sync(&desc->service_outs_intr);
+		unpoison_urbs(desc);
 	}
 	if (!PMSG_IS_AUTO(message)) {
 		mutex_unlock(&desc->wlock);
@@ -1140,7 +1153,7 @@ static int wdm_pre_reset(struct usb_interface *intf)
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
-	kill_urbs(desc);
+	poison_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
 	return 0;
@@ -1151,6 +1164,7 @@ static int wdm_post_reset(struct usb_interface *intf)
 	struct wdm_device *desc = wdm_find_device(intf);
 	int rv;
 
+	unpoison_urbs(desc);
 	clear_bit(WDM_OVERFLOW, &desc->flags);
 	clear_bit(WDM_RESETTING, &desc->flags);
 	rv = recover_from_urb_loss(desc);
-- 
2.31.1


