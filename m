Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A41295AECF2
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241255AbiIFOPm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241283AbiIFOOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:14:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6071E22E;
        Tue,  6 Sep 2022 06:49:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24B0461547;
        Tue,  6 Sep 2022 13:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300EDC433D6;
        Tue,  6 Sep 2022 13:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472073;
        bh=PMTfQciHM3Ym5ZVIcpjWrS8NoZEqnQdmaZEctOuMnmQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/Pc9BZfUxLRsiR9CycPgtjLdMTlerrQkxpc51GwyT4DT176dIVeDE6cpesSt0ryc
         KMI4RTRI1HSbrccoAJ5qt2b+WHI8JpvpUwNFtBgNdy7SCsmCrZrx6yTHgZbGkH+UIn
         otURkcHtlnCPSOyENxDjSYbJovaCxeUYsnzIBujs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Rondreis <linhaoguo86@gmail.com>
Subject: [PATCH 5.19 108/155] media: mceusb: Use new usb_control_msg_*() routines
Date:   Tue,  6 Sep 2022 15:30:56 +0200
Message-Id: <20220906132834.052625141@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 608e58a0f4617977178131f5f68a3fce1d3f5316 upstream.

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

Link: https://lore.kernel.org/all/CAB7eexLLApHJwZfMQ=X-PtRhw0BgO+5KcSMS05FNUYejJXqtSA@mail.gmail.com/
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: stable@vger.kernel.org
Reported-and-tested-by: Rondreis <linhaoguo86@gmail.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/YwkfnBFCSEVC6XZu@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/mceusb.c | 35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

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
-- 
2.37.3



