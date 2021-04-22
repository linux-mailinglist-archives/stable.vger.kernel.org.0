Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59C9367CDA
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 10:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbhDVItO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 04:49:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235637AbhDVItC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Apr 2021 04:49:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04C4961426;
        Thu, 22 Apr 2021 08:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619081305;
        bh=4D/Q/iyVmooilQybCzL4Z8X9DhH0u+CxEs7oHlWnVfQ=;
        h=Subject:To:From:Date:From;
        b=qC/T0gr3GoOwmX/flyGv8Wfasi/lXtPH0hZBbCN3bqlQUjj/6CGvMWd4Tazw58+5W
         FgCI49vAOLPBCISEYR84BNsBJiNmRie8giqD5wtXAQc9A6wA38EITuhjM3F5XG0ZPV
         o5QBaeKwiHcX0zFekY0mbr/+rebbKq+guQSUAxfc=
Subject: patch "usb: gadget: dummy_hcd: fix gpf in gadget_setup" added to usb-testing
To:     mail@anirudhrb.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 22 Apr 2021 10:48:22 +0200
Message-ID: <1619081302230154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: dummy_hcd: fix gpf in gadget_setup

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 4a5d797a9f9c4f18585544237216d7812686a71f Mon Sep 17 00:00:00 2001
From: Anirudh Rayabharam <mail@anirudhrb.com>
Date: Mon, 19 Apr 2021 09:07:08 +0530
Subject: usb: gadget: dummy_hcd: fix gpf in gadget_setup

Fix a general protection fault reported by syzbot due to a race between
gadget_setup() and gadget_unbind() in raw_gadget.

The gadget core is supposed to guarantee that there won't be any more
callbacks to the gadget driver once the driver's unbind routine is
called. That guarantee is enforced in usb_gadget_remove_driver as
follows:

        usb_gadget_disconnect(udc->gadget);
        if (udc->gadget->irq)
                synchronize_irq(udc->gadget->irq);
        udc->driver->unbind(udc->gadget);
        usb_gadget_udc_stop(udc);

usb_gadget_disconnect turns off the pullup resistor, telling the host
that the gadget is no longer connected and preventing the transmission
of any more USB packets. Any packets that have already been received
are sure to processed by the UDC driver's interrupt handler by the time
synchronize_irq returns.

But this doesn't work with dummy_hcd, because dummy_hcd doesn't use
interrupts; it uses a timer instead. It does have code to emulate the
effect of synchronize_irq, but that code doesn't get invoked at the
right time -- it currently runs in usb_gadget_udc_stop, after the unbind
callback instead of before. Indeed, there's no way for
usb_gadget_remove_driver to invoke this code before the unbind callback.

To fix this, move the synchronize_irq() emulation code to dummy_pullup
so that it runs before unbind. Also, add a comment explaining why it is
necessary to have it there.

Reported-by: syzbot+eb4674092e6cc8d9e0bd@syzkaller.appspotmail.com
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Anirudh Rayabharam <mail@anirudhrb.com>
Link: https://lore.kernel.org/r/20210419033713.3021-1-mail@anirudhrb.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index ce24d4f28f2a..7db773c87379 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -903,6 +903,21 @@ static int dummy_pullup(struct usb_gadget *_gadget, int value)
 	spin_lock_irqsave(&dum->lock, flags);
 	dum->pullup = (value != 0);
 	set_link_state(dum_hcd);
+	if (value == 0) {
+		/*
+		 * Emulate synchronize_irq(): wait for callbacks to finish.
+		 * This seems to be the best place to emulate the call to
+		 * synchronize_irq() that's in usb_gadget_remove_driver().
+		 * Doing it in dummy_udc_stop() would be too late since it
+		 * is called after the unbind callback and unbind shouldn't
+		 * be invoked until all the other callbacks are finished.
+		 */
+		while (dum->callback_usage > 0) {
+			spin_unlock_irqrestore(&dum->lock, flags);
+			usleep_range(1000, 2000);
+			spin_lock_irqsave(&dum->lock, flags);
+		}
+	}
 	spin_unlock_irqrestore(&dum->lock, flags);
 
 	usb_hcd_poll_rh_status(dummy_hcd_to_hcd(dum_hcd));
@@ -1004,14 +1019,6 @@ static int dummy_udc_stop(struct usb_gadget *g)
 	spin_lock_irq(&dum->lock);
 	dum->ints_enabled = 0;
 	stop_activity(dum);
-
-	/* emulate synchronize_irq(): wait for callbacks to finish */
-	while (dum->callback_usage > 0) {
-		spin_unlock_irq(&dum->lock);
-		usleep_range(1000, 2000);
-		spin_lock_irq(&dum->lock);
-	}
-
 	dum->driver = NULL;
 	spin_unlock_irq(&dum->lock);
 
-- 
2.31.1


