Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CECC4A0BD7
	for <lists+stable@lfdr.de>; Wed, 28 Aug 2019 22:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfH1UtT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Aug 2019 16:49:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726845AbfH1UtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Aug 2019 16:49:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C10A022DA7;
        Wed, 28 Aug 2019 20:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567025358;
        bh=vQmTIivgpZRNcDqBAPWdh86G4WAZ37mOklBwcl6eDSI=;
        h=Subject:To:From:Date:From;
        b=j2ckWHqji/LwW8xcZBscIGVOenmVPA3utPP4PhWDV/R7YQoDUwgevaOUJ1PclITMe
         X/up/a+AP+sEV7bjFrLPAfBLrBGeyb7Ezg4o5zdWY8SLhATDVzLi7aXiAQvRVmJTWp
         CFnyQGBTjakj3BQbEQushcu50LGVkeOieuXPN/18=
Subject: patch "USB: cdc-wdm: fix race between write and disconnect due to flag abuse" added to usb-linus
To:     oneukum@suse.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 28 Aug 2019 22:49:00 +0200
Message-ID: <1567025340213220@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: cdc-wdm: fix race between write and disconnect due to flag abuse

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1426bd2c9f7e3126e2678e7469dca9fd9fc6dd3e Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 27 Aug 2019 12:34:36 +0200
Subject: USB: cdc-wdm: fix race between write and disconnect due to flag abuse

In case of a disconnect an ongoing flush() has to be made fail.
Nevertheless we cannot be sure that any pending URB has already
finished, so although they will never succeed, they still must
not be touched.
The clean solution for this is to check for WDM_IN_USE
and WDM_DISCONNECTED in flush(). There is no point in ever
clearing WDM_IN_USE, as no further writes make sense.

The issue is as old as the driver.

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Reported-by: syzbot+d232cca6ec42c2edb3fc@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190827103436.21143-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index a7824a51f86d..70afb2ca1eab 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -587,10 +587,20 @@ static int wdm_flush(struct file *file, fl_owner_t id)
 {
 	struct wdm_device *desc = file->private_data;
 
-	wait_event(desc->wait, !test_bit(WDM_IN_USE, &desc->flags));
+	wait_event(desc->wait,
+			/*
+			 * needs both flags. We cannot do with one
+			 * because resetting it would cause a race
+			 * with write() yet we need to signal
+			 * a disconnect
+			 */
+			!test_bit(WDM_IN_USE, &desc->flags) ||
+			test_bit(WDM_DISCONNECTING, &desc->flags));
 
 	/* cannot dereference desc->intf if WDM_DISCONNECTING */
-	if (desc->werr < 0 && !test_bit(WDM_DISCONNECTING, &desc->flags))
+	if (test_bit(WDM_DISCONNECTING, &desc->flags))
+		return -ENODEV;
+	if (desc->werr < 0)
 		dev_err(&desc->intf->dev, "Error in flush path: %d\n",
 			desc->werr);
 
@@ -974,8 +984,6 @@ static void wdm_disconnect(struct usb_interface *intf)
 	spin_lock_irqsave(&desc->iuspin, flags);
 	set_bit(WDM_DISCONNECTING, &desc->flags);
 	set_bit(WDM_READ, &desc->flags);
-	/* to terminate pending flushes */
-	clear_bit(WDM_IN_USE, &desc->flags);
 	spin_unlock_irqrestore(&desc->iuspin, flags);
 	wake_up_all(&desc->wait);
 	mutex_lock(&desc->rlock);
-- 
2.23.0


