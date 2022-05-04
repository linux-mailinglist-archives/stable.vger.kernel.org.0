Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 356C851A61D
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353800AbiEDQwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353804AbiEDQwa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FAF741618;
        Wed,  4 May 2022 09:48:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AEE556177E;
        Wed,  4 May 2022 16:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8326C385BE;
        Wed,  4 May 2022 16:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682919;
        bh=KsqWvYLVRjlEAJbhnz+ONW7lnehp7LuvzpxldtWlav8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkkHV3BjynWI9Zxonbf8IpWmDOc0q03pOb2WxSR4Pr3+t8bPCDkYV6+b3UHJ9JqCo
         Jy9XWzmcpWazxOHaV8wWeLoEoMrkTk8lEBsKkRD3jflKX1RzGeY8t5QKo+W47t2AlW
         x8S+FOod1yPWGwS2bIszdxwchy4DTn7mM7Lho9D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        syzbot+53ce4a4246d0fe0fee34@syzkaller.appspotmail.com
Subject: [PATCH 5.4 29/84] video: fbdev: udlfb: properly check endpoint type
Date:   Wed,  4 May 2022 18:44:10 +0200
Message-Id: <20220504152929.823123508@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit aaf7dbe07385e0b8deb7237eca2a79926bbc7091 ]

syzbot reported warning in usb_submit_urb, which is caused by wrong
endpoint type.

This driver uses out bulk endpoint for communication, so
let's check if this endpoint is present and bail out early if not.

Fail log:

usb 1-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 0 PID: 4822 at drivers/usb/core/urb.c:493 usb_submit_urb+0xd27/0x1540 drivers/usb/core/urb.c:493
Modules linked in:
CPU: 0 PID: 4822 Comm: kworker/0:3 Tainted: G        W         5.13.0-syzkaller #0
...
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_submit_urb+0xd27/0x1540 drivers/usb/core/urb.c:493
...
Call Trace:
 dlfb_submit_urb+0x89/0x160 drivers/video/fbdev/udlfb.c:1969
 dlfb_set_video_mode+0x21f0/0x2950 drivers/video/fbdev/udlfb.c:315
 dlfb_ops_set_par+0x2a3/0x840 drivers/video/fbdev/udlfb.c:1110
 dlfb_usb_probe.cold+0x113e/0x1f4a drivers/video/fbdev/udlfb.c:1732
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396

Fixes: 88e58b1a42f8 ("Staging: add udlfb driver")
Reported-and-tested-by: syzbot+53ce4a4246d0fe0fee34@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/udlfb.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index e269b1391e14..8e8af408998e 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1650,8 +1650,9 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 	const struct device_attribute *attr;
 	struct dlfb_data *dlfb;
 	struct fb_info *info;
-	int retval = -ENOMEM;
+	int retval;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *out;
 
 	/* usb initialization */
 	dlfb = kzalloc(sizeof(*dlfb), GFP_KERNEL);
@@ -1665,6 +1666,12 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 	dlfb->udev = usb_get_dev(usbdev);
 	usb_set_intfdata(intf, dlfb);
 
+	retval = usb_find_common_endpoints(intf->cur_altsetting, NULL, &out, NULL, NULL);
+	if (retval) {
+		dev_err(&intf->dev, "Device should have at lease 1 bulk endpoint!\n");
+		goto error;
+	}
+
 	dev_dbg(&intf->dev, "console enable=%d\n", console);
 	dev_dbg(&intf->dev, "fb_defio enable=%d\n", fb_defio);
 	dev_dbg(&intf->dev, "shadow enable=%d\n", shadow);
@@ -1674,6 +1681,7 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 	if (!dlfb_parse_vendor_descriptor(dlfb, intf)) {
 		dev_err(&intf->dev,
 			"firmware not recognized, incompatible device?\n");
+		retval = -ENODEV;
 		goto error;
 	}
 
@@ -1687,8 +1695,10 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 
 	/* allocates framebuffer driver structure, not framebuffer memory */
 	info = framebuffer_alloc(0, &dlfb->udev->dev);
-	if (!info)
+	if (!info) {
+		retval = -ENOMEM;
 		goto error;
+	}
 
 	dlfb->info = info;
 	info->par = dlfb;
-- 
2.35.1



