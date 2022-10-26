Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F94760E436
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 17:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234178AbiJZPLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 11:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234476AbiJZPLR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 11:11:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FB06525F
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 08:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 433D8B822C3
        for <stable@vger.kernel.org>; Wed, 26 Oct 2022 15:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9864DC433C1;
        Wed, 26 Oct 2022 15:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666797073;
        bh=yHNaPgBDoDx5eUKt6HUz2JEMWKwq4jE8bDsafnumdEw=;
        h=Subject:To:Cc:From:Date:From;
        b=V9Ys8SR/vzm+pzXnHYeNQljE4fWV/i9ukHRYS0JokYCWeIzWTMHipIaWMiGBkL2VG
         vLTp6r2QvLKSUbuUWWWYIaIzM8p6nGhldbmgqL3jehqhjmWABE5u3mWMGNAhvJ3Ufw
         ccSKitrCcaer3/FWlAZmPQECf/w2ExPuXbH4pLRA=
Subject: FAILED: patch "[PATCH] media: mceusb: Use new usb_control_msg_*() routines" failed to apply to 5.10-stable tree
To:     stern@rowland.harvard.edu, linhaoguo86@gmail.com,
        mchehab@kernel.org, sean@mess.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Oct 2022 17:11:07 +0200
Message-ID: <166679706717115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

41fd1cb61514 ("media: mceusb: Use new usb_control_msg_*() routines")
16394e998cbb ("media: mceusb: fix control-message timeouts")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 41fd1cb6151439b205ac7611883d85ae14250172 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Fri, 26 Aug 2022 21:31:40 +0200
Subject: [PATCH] media: mceusb: Use new usb_control_msg_*() routines

Automatic kernel fuzzing led to a WARN about invalid pipe direction in
the mceusb driver:

------------[ cut here ]------------
usb 6-1: BOGUS control dir, pipe 80000380 doesn't match bRequestType 40
WARNING: CPU: 0 PID: 2465 at drivers/usb/core/urb.c:410
usb_submit_urb+0x1326/0x1820 drivers/usb/core/urb.c:410
Modules linked in:
CPU: 0 PID: 2465 Comm: kworker/0:2 Not tainted 5.19.0-rc4-00208-g69cb6c6556ad #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_submit_urb+0x1326/0x1820 drivers/usb/core/urb.c:410
Code: 7c 24 40 e8 ac 23 91 fd 48 8b 7c 24 40 e8 b2 70 1b ff 45 89 e8
44 89 f1 4c 89 e2 48 89 c6 48 c7 c7 a0 30 a9 86 e8 48 07 11 02 <0f> 0b
e9 1c f0 ff ff e8 7e 23 91 fd 0f b6 1d 63 22 83 05 31 ff 41
RSP: 0018:ffffc900032becf0 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8881100f3058 RCX: 0000000000000000
RDX: ffffc90004961000 RSI: ffff888114c6d580 RDI: fffff52000657d90
RBP: ffff888105ad90f0 R08: ffffffff812c3638 R09: 0000000000000000
R10: 0000000000000005 R11: ffffed1023504ef1 R12: ffff888105ad9000
R13: 0000000000000040 R14: 0000000080000380 R15: ffff88810ba96500
FS: 0000000000000000(0000) GS:ffff88811a800000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe810bda58 CR3: 000000010b720000 CR4: 0000000000350ef0
Call Trace:
<TASK>
usb_start_wait_urb+0x101/0x4c0 drivers/usb/core/message.c:58
usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
mceusb_gen1_init drivers/media/rc/mceusb.c:1431 [inline]
mceusb_dev_probe+0x258e/0x33f0 drivers/media/rc/mceusb.c:1807

The reason for the warning is clear enough; the driver sends an
unusual read request on endpoint 0 but does not set the USB_DIR_IN bit
in the bRequestType field.

More importantly, the whole situation can be avoided and the driver
simplified by converting it over to the relatively new
usb_control_msg_recv() and usb_control_msg_send() routines.  That's
what this fix does.

Reported-and-tested-by: Rondreis <linhaoguo86@gmail.com>
Link: https://lore.kernel.org/all/CAB7eexLLApHJwZfMQ=X-PtRhw0BgO+5KcSMS05FNUYejJXqtSA@mail.gmail.com/

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 0834d5f866fd..39d2b03e2631 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1416,42 +1416,37 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 {
 	int ret;
 	struct device *dev = ir->dev;
-	char *data;
-
-	data = kzalloc(USB_CTRL_MSG_SZ, GFP_KERNEL);
-	if (!data) {
-		dev_err(dev, "%s: memory allocation failed!", __func__);
-		return;
-	}
+	char data[USB_CTRL_MSG_SZ];
 
 	/*
 	 * This is a strange one. Windows issues a set address to the device
 	 * on the receive control pipe and expect a certain value pair back
 	 */
-	ret = usb_control_msg(ir->usbdev, usb_rcvctrlpipe(ir->usbdev, 0),
-			      USB_REQ_SET_ADDRESS, USB_TYPE_VENDOR, 0, 0,
-			      data, USB_CTRL_MSG_SZ, 3000);
+	ret = usb_control_msg_recv(ir->usbdev, 0, USB_REQ_SET_ADDRESS,
+				   USB_DIR_IN | USB_TYPE_VENDOR,
+				   0, 0, data, USB_CTRL_MSG_SZ, 3000,
+				   GFP_KERNEL);
 	dev_dbg(dev, "set address - ret = %d", ret);
 	dev_dbg(dev, "set address - data[0] = %d, data[1] = %d",
 						data[0], data[1]);
 
 	/* set feature: bit rate 38400 bps */
-	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
-			      USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
-			      0xc04e, 0x0000, NULL, 0, 3000);
+	ret = usb_control_msg_send(ir->usbdev, 0,
+				   USB_REQ_SET_FEATURE, USB_TYPE_VENDOR,
+				   0xc04e, 0x0000, NULL, 0, 3000, GFP_KERNEL);
 
 	dev_dbg(dev, "set feature - ret = %d", ret);
 
 	/* bRequest 4: set char length to 8 bits */
-	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
-			      4, USB_TYPE_VENDOR,
-			      0x0808, 0x0000, NULL, 0, 3000);
+	ret = usb_control_msg_send(ir->usbdev, 0,
+				   4, USB_TYPE_VENDOR,
+				   0x0808, 0x0000, NULL, 0, 3000, GFP_KERNEL);
 	dev_dbg(dev, "set char length - retB = %d", ret);
 
 	/* bRequest 2: set handshaking to use DTR/DSR */
-	ret = usb_control_msg(ir->usbdev, usb_sndctrlpipe(ir->usbdev, 0),
-			      2, USB_TYPE_VENDOR,
-			      0x0000, 0x0100, NULL, 0, 3000);
+	ret = usb_control_msg_send(ir->usbdev, 0,
+				   2, USB_TYPE_VENDOR,
+				   0x0000, 0x0100, NULL, 0, 3000, GFP_KERNEL);
 	dev_dbg(dev, "set handshake  - retC = %d", ret);
 
 	/* device resume */
@@ -1459,8 +1454,6 @@ static void mceusb_gen1_init(struct mceusb_dev *ir)
 
 	/* get hw/sw revision? */
 	mce_command_out(ir, GET_REVISION, sizeof(GET_REVISION));
-
-	kfree(data);
 }
 
 static void mceusb_gen2_init(struct mceusb_dev *ir)

