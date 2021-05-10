Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E8037852C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhEJK72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233803AbhEJKzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D40D961C21;
        Mon, 10 May 2021 10:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643352;
        bh=j8ZAVh+4owLROopi+7mVLqIA4y5/4WyTB2uWaa5L3uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKPw9MSFvT+q7CbDYo42DmgQy5iLvC3oeMISFKkaHcAANxYWGEfMvcJjwABOviPDK
         rJvdqx6YfZwhD7/pTv3O9J7JqAExWgVMoaltZSJkNvIMQufKuSA/et7+NL8MrHBrWj
         5LIL/HgpOicPssvXffXbNGzLFcCceNkP6PTaz9ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+eb4674092e6cc8d9e0bd@syzkaller.appspotmail.com,
        Alan Stern <stern@rowland.harvard.edu>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Subject: [PATCH 5.10 281/299] usb: gadget: dummy_hcd: fix gpf in gadget_setup
Date:   Mon, 10 May 2021 12:21:18 +0200
Message-Id: <20210510102014.213277954@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Rayabharam <mail@anirudhrb.com>

commit 4a5d797a9f9c4f18585544237216d7812686a71f upstream.

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
 drivers/usb/gadget/udc/dummy_hcd.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -901,6 +901,21 @@ static int dummy_pullup(struct usb_gadge
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
@@ -1002,14 +1017,6 @@ static int dummy_udc_stop(struct usb_gad
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
 


