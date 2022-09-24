Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1995E88C9
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 08:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiIXGnU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 02:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbiIXGnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 02:43:19 -0400
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D3711D0D1
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 23:43:18 -0700 (PDT)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1obysd-009Grw-He; Sat, 24 Sep 2022 06:43:15 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sat, 24 Sep 2022 05:49:45 +0000
Subject: [git:media_stage/master] media: mceusb: Use new usb_control_msg_*() routines
To:     linuxtv-commits@linuxtv.org
Cc:     Rondreis <linhaoguo86@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sean Young <sean@mess.org>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1obysd-009Grw-He@www.linuxtv.org>
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: mceusb: Use new usb_control_msg_*() routines
Author:  Alan Stern <stern@rowland.harvard.edu>
Date:    Fri Aug 26 21:31:40 2022 +0200

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

 drivers/media/rc/mceusb.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

---

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
