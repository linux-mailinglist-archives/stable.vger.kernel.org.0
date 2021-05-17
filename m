Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 738A0383818
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239307AbhEQPst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245623AbhEQPqg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:46:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CDE3761D38;
        Mon, 17 May 2021 14:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262670;
        bh=w1dN5sX4ZZCG3Slp7G3V4sFe3WQRgF+QCwDfjW+QruQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrgBI18dSlykgiXb19aqIw0zW+dUJ4uaBzucBiD6lVd6Pdon3DVFdCH7ZjhzZPevD
         QREo7X5uk1yDYd4V4g5iBPTTCSLcQERWtyKWZG4Sq90Hx5n1eRlhDT9pskUjZjyBAw
         E07FV7GqMZZWze4icuH+WbaSBSzW8hw7KfbgZqkY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 254/289] cdc-wdm: untangle a circular dependency between callback and softint
Date:   Mon, 17 May 2021 16:02:59 +0200
Message-Id: <20210517140313.694965267@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 18abf874367456540846319574864e6ff32752e2 upstream.

We have a cycle of callbacks scheduling works which submit
URBs with those callbacks. This needs to be blocked, stopped
and unblocked to untangle the circle.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20210426092622.20433-1-oneukum@suse.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -321,12 +321,23 @@ exit:
 
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
@@ -741,11 +752,12 @@ static int wdm_release(struct inode *ino
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
@@ -1037,9 +1049,9 @@ static void wdm_disconnect(struct usb_in
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
+	poison_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
-	kill_urbs(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
 
@@ -1080,9 +1092,10 @@ static int wdm_suspend(struct usb_interf
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
@@ -1140,7 +1153,7 @@ static int wdm_pre_reset(struct usb_inte
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
-	kill_urbs(desc);
+	poison_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
 	return 0;
@@ -1151,6 +1164,7 @@ static int wdm_post_reset(struct usb_int
 	struct wdm_device *desc = wdm_find_device(intf);
 	int rv;
 
+	unpoison_urbs(desc);
 	clear_bit(WDM_OVERFLOW, &desc->flags);
 	clear_bit(WDM_RESETTING, &desc->flags);
 	rv = recover_from_urb_loss(desc);


