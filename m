Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91105AEB34
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiIFNov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238621AbiIFNnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:43:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85B17E80E;
        Tue,  6 Sep 2022 06:37:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5574F6155D;
        Tue,  6 Sep 2022 13:37:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549D0C433D6;
        Tue,  6 Sep 2022 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471470;
        bh=KCYVDvpvQe2eUYuOXORu4L3Gx2Nzf80om5ePm4Nj7zM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J/iop4yOdePOPrBHMDJlz7FuaT4AXhW7XTNm5AtK9ya6KOZ332wMUFtQ963nP9Iso
         AC0XL0oj0VastMdOwfocI+tr32uMA7lkJvnpuhaDeYqEcDTL8jwjM1sqA35igHp4rd
         X1RRswS8HzPjz4q4S0W4PWk9j73+NZvZiJQhLaCM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+deb6abc36aad4008f407@syzkaller.appspotmail.com>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Hillf Danton <hdanton@sina.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 038/107] Input: iforce - wake up after clearing IFORCE_XMIT_RUNNING flag
Date:   Tue,  6 Sep 2022 15:30:19 +0200
Message-Id: <20220906132823.412622209@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

commit 98e01215708b6d416345465c09dce2bd4868c67a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/iforce/iforce-serio.c |    6 +++---
 drivers/input/joystick/iforce/iforce-usb.c   |    8 ++++----
 drivers/input/joystick/iforce/iforce.h       |    6 ++++++
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/input/joystick/iforce/iforce-serio.c
+++ b/drivers/input/joystick/iforce/iforce-serio.c
@@ -39,7 +39,7 @@ static void iforce_serio_xmit(struct ifo
 
 again:
 	if (iforce->xmit.head == iforce->xmit.tail) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+		iforce_clear_xmit_and_wake(iforce);
 		spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 		return;
 	}
@@ -64,7 +64,7 @@ again:
 	if (test_and_clear_bit(IFORCE_XMIT_AGAIN, iforce->xmit_flags))
 		goto again;
 
-	clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+	iforce_clear_xmit_and_wake(iforce);
 
 	spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 }
@@ -169,7 +169,7 @@ static irqreturn_t iforce_serio_irq(stru
 			iforce_serio->cmd_response_len = iforce_serio->len;
 
 			/* Signal that command is done */
-			wake_up(&iforce->wait);
+			wake_up_all(&iforce->wait);
 		} else if (likely(iforce->type)) {
 			iforce_process_packet(iforce, iforce_serio->id,
 					      iforce_serio->data_in,
--- a/drivers/input/joystick/iforce/iforce-usb.c
+++ b/drivers/input/joystick/iforce/iforce-usb.c
@@ -30,7 +30,7 @@ static void __iforce_usb_xmit(struct ifo
 	spin_lock_irqsave(&iforce->xmit_lock, flags);
 
 	if (iforce->xmit.head == iforce->xmit.tail) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
+		iforce_clear_xmit_and_wake(iforce);
 		spin_unlock_irqrestore(&iforce->xmit_lock, flags);
 		return;
 	}
@@ -58,9 +58,9 @@ static void __iforce_usb_xmit(struct ifo
 	XMIT_INC(iforce->xmit.tail, n);
 
 	if ( (n=usb_submit_urb(iforce_usb->out, GFP_ATOMIC)) ) {
-		clear_bit(IFORCE_XMIT_RUNNING, iforce->xmit_flags);
 		dev_warn(&iforce_usb->intf->dev,
 			 "usb_submit_urb failed %d\n", n);
+		iforce_clear_xmit_and_wake(iforce);
 	}
 
 	/* The IFORCE_XMIT_RUNNING bit is not cleared here. That's intended.
@@ -175,15 +175,15 @@ static void iforce_usb_out(struct urb *u
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
--- a/drivers/input/joystick/iforce/iforce.h
+++ b/drivers/input/joystick/iforce/iforce.h
@@ -119,6 +119,12 @@ static inline int iforce_get_id_packet(s
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


