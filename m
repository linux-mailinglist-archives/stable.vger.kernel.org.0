Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761CD38A51B
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbhETKNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:13:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235339AbhETKKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9895761962;
        Thu, 20 May 2021 09:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503796;
        bh=o2ClhNsihdFHp/MeCscPR0OLjzqGCZLrRloaQQd2m6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmtYeXpnN4WQKT1hOOjB7Yj7kjCa4kQ54rWDQvqlMvvDAUltxpocESNjauQWRaPAC
         6e7eBDihLdxusQ/R8xhZCqHS7nlzBQrWirlhMribJph9SRpR/cahzQS2Ts2bWWh6Ta
         X8L8yAbAvbalSjgc9L9n+oyFTyk7M83SlTN1LIcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.19 383/425] cdc-wdm: untangle a circular dependency between callback and softint
Date:   Thu, 20 May 2021 11:22:32 +0200
Message-Id: <20210520092143.988407738@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -1036,9 +1048,9 @@ static void wdm_disconnect(struct usb_in
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
+	poison_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
-	kill_urbs(desc);
 	mutex_unlock(&desc->wlock);
 	mutex_unlock(&desc->rlock);
 
@@ -1079,9 +1091,10 @@ static int wdm_suspend(struct usb_interf
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
@@ -1139,7 +1152,7 @@ static int wdm_pre_reset(struct usb_inte
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
 	mutex_lock(&desc->wlock);
-	kill_urbs(desc);
+	poison_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
 	return 0;
@@ -1150,6 +1163,7 @@ static int wdm_post_reset(struct usb_int
 	struct wdm_device *desc = wdm_find_device(intf);
 	int rv;
 
+	unpoison_urbs(desc);
 	clear_bit(WDM_OVERFLOW, &desc->flags);
 	clear_bit(WDM_RESETTING, &desc->flags);
 	rv = recover_from_urb_loss(desc);


