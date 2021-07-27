Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C4E3D7796
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 15:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236576AbhG0N4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 09:56:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:51128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232185AbhG0N4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Jul 2021 09:56:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BE8461AA5;
        Tue, 27 Jul 2021 13:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627394170;
        bh=rfGgKS2Dh5NeYNDzsBzD/yFhlRRIZYIoz+TPhxg0Kzs=;
        h=Subject:To:From:Date:From;
        b=V/Z+5TpRUGZFjXxZ/QGgKu9V2bCXvLfbUHZCfGs98MrwmxshLXr63odTQHUMepDwu
         cLuYzU83GfuOhlPXwG6JqfNk//afELIgq8FD/HSIhN9+x11pbn0EnKF5qbhGKgsTAa
         obAkAbpkm2DFV7Iju9qFo43dtuv3dSK6FlIS9PXI=
Subject: patch "usb: gadget: f_hid: fixed NULL pointer dereference" added to usb-linus
To:     phil@raspberrypi.com, gregkh@linuxfoundation.org,
        mdevaev@gmail.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 27 Jul 2021 15:55:58 +0200
Message-ID: <1627394158233165@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: f_hid: fixed NULL pointer dereference

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2867652e4766360adf14dfda3832455e04964f2a Mon Sep 17 00:00:00 2001
From: Phil Elwell <phil@raspberrypi.com>
Date: Fri, 23 Jul 2021 18:59:30 +0300
Subject: usb: gadget: f_hid: fixed NULL pointer dereference

Disconnecting and reconnecting the USB cable can lead to crashes
and a variety of kernel log spam.

The problem was found and reproduced on the Raspberry Pi [1]
and the original fix was created in Raspberry's own fork [2].

Link: https://github.com/raspberrypi/linux/issues/3870 [1]
Link: https://github.com/raspberrypi/linux/commit/a6e47d5f4efbd2ea6a0b6565cd2f9b7bb217ded5 [2]
Signed-off-by: Maxim Devaev <mdevaev@gmail.com>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210723155928.210019-1-mdevaev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_hid.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 02683ac0719d..08e73e8127b1 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -338,6 +338,11 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 
 	spin_lock_irqsave(&hidg->write_spinlock, flags);
 
+	if (!hidg->req) {
+		spin_unlock_irqrestore(&hidg->write_spinlock, flags);
+		return -ESHUTDOWN;
+	}
+
 #define WRITE_COND (!hidg->write_pending)
 try_again:
 	/* write queue */
@@ -358,8 +363,14 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 	count  = min_t(unsigned, count, hidg->report_length);
 
 	spin_unlock_irqrestore(&hidg->write_spinlock, flags);
-	status = copy_from_user(req->buf, buffer, count);
 
+	if (!req) {
+		ERROR(hidg->func.config->cdev, "hidg->req is NULL\n");
+		status = -ESHUTDOWN;
+		goto release_write_pending;
+	}
+
+	status = copy_from_user(req->buf, buffer, count);
 	if (status != 0) {
 		ERROR(hidg->func.config->cdev,
 			"copy_from_user error\n");
@@ -387,14 +398,17 @@ static ssize_t f_hidg_write(struct file *file, const char __user *buffer,
 
 	spin_unlock_irqrestore(&hidg->write_spinlock, flags);
 
+	if (!hidg->in_ep->enabled) {
+		ERROR(hidg->func.config->cdev, "in_ep is disabled\n");
+		status = -ESHUTDOWN;
+		goto release_write_pending;
+	}
+
 	status = usb_ep_queue(hidg->in_ep, req, GFP_ATOMIC);
-	if (status < 0) {
-		ERROR(hidg->func.config->cdev,
-			"usb_ep_queue error on int endpoint %zd\n", status);
+	if (status < 0)
 		goto release_write_pending;
-	} else {
+	else
 		status = count;
-	}
 
 	return status;
 release_write_pending:
-- 
2.32.0


