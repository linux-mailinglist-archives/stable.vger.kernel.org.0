Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00F7651A880
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356155AbiEDRLT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356926AbiEDRJt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7F94738D;
        Wed,  4 May 2022 09:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEA72617A6;
        Wed,  4 May 2022 16:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28DC5C385AA;
        Wed,  4 May 2022 16:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683387;
        bh=2AHMO1rt09lcgtSq7YM7IIDJOOXaAVwLycWd1FnTCxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JyUluXrLQfaVwneNAFkOfb/ATq/40wEBpIsLny+ZNk84Htqv6FBJAxayNeXA89z6t
         Z7gy4280Iu7rtkdZSypTCV8G9JEav3VQEYBorJdU/zbCES/jmkdBMco/7GBVmz91dM
         Ku2EVgBivokv6gt+VWMJXmj6k1u01M3+M4Nk4scc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>,
        syzbot+53ce4a4246d0fe0fee34@syzkaller.appspotmail.com
Subject: [PATCH 5.17 059/225] video: fbdev: udlfb: properly check endpoint type
Date:   Wed,  4 May 2022 18:44:57 +0200
Message-Id: <20220504153115.436114773@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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
index 90f48b71fd8f..d9eec1b60e66 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1649,8 +1649,9 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 	const struct device_attribute *attr;
 	struct dlfb_data *dlfb;
 	struct fb_info *info;
-	int retval = -ENOMEM;
+	int retval;
 	struct usb_device *usbdev = interface_to_usbdev(intf);
+	struct usb_endpoint_descriptor *out;
 
 	/* usb initialization */
 	dlfb = kzalloc(sizeof(*dlfb), GFP_KERNEL);
@@ -1664,6 +1665,12 @@ static int dlfb_usb_probe(struct usb_interface *intf,
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
@@ -1673,6 +1680,7 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 	if (!dlfb_parse_vendor_descriptor(dlfb, intf)) {
 		dev_err(&intf->dev,
 			"firmware not recognized, incompatible device?\n");
+		retval = -ENODEV;
 		goto error;
 	}
 
@@ -1686,8 +1694,10 @@ static int dlfb_usb_probe(struct usb_interface *intf,
 
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



