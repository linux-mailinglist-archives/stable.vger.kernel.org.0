Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98695AD6F5
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 17:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231629AbiIEPz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 11:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbiIEPz3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 11:55:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B789E27FFC
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 08:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6954FB81200
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 15:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A1DC433D7;
        Mon,  5 Sep 2022 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662393325;
        bh=pMoxPBfPdCsX7+JsHKk2kACL2fNuO/AKW9zHauquYrM=;
        h=Subject:To:Cc:From:Date:From;
        b=TiAdyHZqMuhFhTBpEdzKGpa/PcFKDpFBsO2smJA0t5YytZQR0aYNGfPMx7Jq0tM73
         dicdnryV//xHaP5J+57O2RgeS9BkriQE5eZzuHNTHZwrJgn5dwq8V/5EYpiHsJ4Ypa
         JGxtl1AouGJynBKsewo/Pq8FyURh0Tp4WHrssTMA=
Subject: FAILED: patch "[PATCH] Input: iforce - wake up after clearing IFORCE_XMIT_RUNNING" failed to apply to 4.9-stable tree
To:     penguin-kernel@I-love.SAKURA.ne.jp, dmitry.torokhov@gmail.com,
        fmdefrancesco@gmail.com, hdanton@sina.com,
        syzbot+deb6abc36aad4008f407@syzkaller.appspotmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Sep 2022 17:55:14 +0200
Message-ID: <1662393314205214@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 98e01215708b6d416345465c09dce2bd4868c67a Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Sat, 27 Aug 2022 20:36:27 -0700
Subject: [PATCH] Input: iforce - wake up after clearing IFORCE_XMIT_RUNNING
 flag

syzbot is reporting hung task at __input_unregister_device() [1], for
iforce_close() waiting at wait_event_interruptible() with dev->mutex held
is blocking input_disconnect_device() from __input_unregister_device().

It seems that the cause is simply that commit c2b27ef672992a20 ("Input:
iforce - wait for command completion when closing the device") forgot to
call wake_up() after clear_bit().

Fix this problem by introducing a helper that calls clear_bit() followed
by wake_up_all().

Reported-by: syzbot <syzbot+deb6abc36aad4008f407@syzkaller.appspotmail.com>
Fixes: c2b27ef672992a20 ("Input: iforce - wait for command completion when closing the device")
Tested-by: syzbot <syzbot+deb6abc36aad4008f407@syzkaller.appspotmail.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Co-developed-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Hillf Danton <hdanton@sina.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/887021c3-4f13-40ce-c8b9-aa6e09faa3a7@I-love.SAKURA.ne.jp
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

diff --git a/drivers/input/joystick/iforce/iforce-serio.c b/drivers/input/joystick/iforce/iforce-serio.c
index f95a81b9fac7..2380546d7978 100644
--- a/drivers/input/joystick/iforce/iforce-serio.c
+++ b/drivers/input/joystick/iforce/iforce-serio.c
@@ -39,7 +39,7 @@ static void iforce_serio_xmit(struct iforce *iforce)
 
 again:
 	if (iforce->xmit.head == iforce->xmit.tail) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+		iforce_clear_xmit_and_wake(iforce);
 		spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 		return;
 	}
@@ -64,7 +64,7 @@ static void iforce_serio_xmit(struct iforce *iforce)
 	if (test_and_clear_bit(IFORCE_XMIT_AGAIN, iforce->xmit_flags))
 		goto again;
 
-	clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+	iforce_clear_xmit_and_wake(iforce);
 
 	spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 }
@@ -169,7 +169,7 @@ static irqreturn_t iforce_serio_irq(struct serio *serio,
 			iforce_serio->cmd_response_len = iforce_serio->len;
 
 			/* Signal that command is done */
-			wake_up(&iforce->wait);
+			wake_up_all(&iforce->wait);
 		} else if (likely(iforce->type)) {
 			iforce_process_packet(iforce, iforce_serio->id,
 					      iforce_serio->data_in,
diff --git a/drivers/input/joystick/iforce/iforce-usb.c b/drivers/input/joystick/iforce/iforce-usb.c
index ea58805c480f..cba92bd590a8 100644
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -30,7 +30,7 @@ static void __iforce_usb_xmit(struct iforce *iforce)
 	spin_lock_irqsave(&iforce->xmit_lock, flags);
 
 	if (iforce->xmit.head == iforce->xmit.tail) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+		iforce_clear_xmit_and_wake(iforce);
 		spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 		return;
 	}
@@ -58,9 +58,9 @@ static void __iforce_usb_xmit(struct iforce *iforce)
 	XMIT_INC(iforce->xmit.tail, n);
 
 	if ( (n=usb_submit_urb(iforce_usb->out, GFP_ATOMIC)) ) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
 		dev_warn(&iforce_usb->intf->dev,
 			 "usb_submit_urb failed %d\n", n);
+		iforce_clear_xmit_and_wake(iforce);
 	}
 
 	/* The IFORCE_XMIT_RUNNING bit is not cleared here. That's intended.
@@ -175,15 +175,15 @@ static void iforce_usb_out(struct urb *urb)
 	struct iforce *iforce = &iforce_usb->iforce;
 
 	if (urb->status) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
 		dev_dbg(&iforce_usb->intf->dev, "urb->status %d, exiting\n",
 			urb->status);
+		iforce_clear_xmit_and_wake(iforce);
 		return;
 	}
 
 	__iforce_usb_xmit(iforce);
 
-	wake_up(&iforce->wait);
+	wake_up_all(&iforce->wait);
 }
 
 static int iforce_usb_probe(struct usb_interface *intf,
diff --git a/drivers/input/joystick/iforce/iforce.h b/drivers/input/joystick/iforce/iforce.h
index 6aa761ebbdf7..9ccb9107ccbe 100644
--- a/drivers/input/joystick/iforce/iforce.h
+++ b/drivers/input/joystick/iforce/iforce.h
@@ -119,6 +119,12 @@ static inline int iforce_get_id_packet(struct iforce *iforce, u8 id,
 					 response_data, response_len);
 }
 
+static inline void iforce_clear_xmit_and_wake(struct iforce *iforce)
+{
+	clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+	wake_up_all(&iforce->wait);
+}
+
 /* Public functions */
 /* iforce-main.c */
 int iforce_init_device(struct device *parent, u16 bustype,

