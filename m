Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8CD694A08
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 16:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbjBMPEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 10:04:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjBMPEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 10:04:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619E01E1E5
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 07:03:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E693661122
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 15:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0778AC433EF;
        Mon, 13 Feb 2023 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300627;
        bh=xC04bUYkYkPLu9Ciq5SLazJsdAW35MmdtMKKCPwcEB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UsF8VahLp5PZekh7aU+tcdrcYat5o4BfzEaC1cCp3xr8GLe8/s8eQ92KRjOLXRIwl
         8NnGREcbuf3h5bSN48X1+155aSEdK+AcvuL7I1xDYOsI9+QAnKO9j7wZvldyXcdpFc
         qVlF5hDBliHnzAO5aXvrTb1YasMqqWn8vsfyQ0O0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, syzkaller <syzkaller@googlegroups.com>,
        Dongliang Mu <dzm91@hust.edu.cn>, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 086/139] fbdev: smscufx: fix error handling code in ufx_usb_probe
Date:   Mon, 13 Feb 2023 15:50:31 +0100
Message-Id: <20230213144750.386726854@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongliang Mu <dzm91@hust.edu.cn>

commit b76449ee75e21acfe9fa4c653d8598f191ed7d68 upstream.

The current error handling code in ufx_usb_probe have many unmatching
issues, e.g., missing ufx_free_usb_list, destroy_modedb label should
only include framebuffer_release, fb_dealloc_cmap only matches
fb_alloc_cmap.

My local syzkaller reports a memory leak bug:

memory leak in ufx_usb_probe

BUG: memory leak
unreferenced object 0xffff88802f879580 (size 128):
  comm "kworker/0:7", pid 17416, jiffies 4295067474 (age 46.710s)
  hex dump (first 32 bytes):
    80 21 7c 2e 80 88 ff ff 18 d0 d0 0c 80 88 ff ff  .!|.............
    00 d0 d0 0c 80 88 ff ff e0 ff ff ff 0f 00 00 00  ................
  backtrace:
    [<ffffffff814c99a0>] kmalloc_trace+0x20/0x90 mm/slab_common.c:1045
    [<ffffffff824d219c>] kmalloc include/linux/slab.h:553 [inline]
    [<ffffffff824d219c>] kzalloc include/linux/slab.h:689 [inline]
    [<ffffffff824d219c>] ufx_alloc_urb_list drivers/video/fbdev/smscufx.c:1873 [inline]
    [<ffffffff824d219c>] ufx_usb_probe+0x11c/0x15a0 drivers/video/fbdev/smscufx.c:1655
    [<ffffffff82d17927>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<ffffffff82712f0d>] call_driver_probe drivers/base/dd.c:560 [inline]
    [<ffffffff82712f0d>] really_probe+0x12d/0x390 drivers/base/dd.c:639
    [<ffffffff8271322f>] __driver_probe_device+0xbf/0x140 drivers/base/dd.c:778
    [<ffffffff827132da>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:808
    [<ffffffff82713c27>] __device_attach_driver+0xf7/0x150 drivers/base/dd.c:936
    [<ffffffff82710137>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff827136b5>] __device_attach+0x105/0x2d0 drivers/base/dd.c:1008
    [<ffffffff82711d36>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:487
    [<ffffffff8270e242>] device_add+0x642/0xdc0 drivers/base/core.c:3517
    [<ffffffff82d14d5f>] usb_set_configuration+0x8ef/0xb80 drivers/usb/core/message.c:2170
    [<ffffffff82d2576c>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<ffffffff82d16ffc>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<ffffffff82712f0d>] call_driver_probe drivers/base/dd.c:560 [inline]
    [<ffffffff82712f0d>] really_probe+0x12d/0x390 drivers/base/dd.c:639
    [<ffffffff8271322f>] __driver_probe_device+0xbf/0x140 drivers/base/dd.c:778

Fix this bug by rewriting the error handling code in ufx_usb_probe.

Reported-by: syzkaller <syzkaller@googlegroups.com>
Tested-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/smscufx.c |   46 ++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 15 deletions(-)

--- a/drivers/video/fbdev/smscufx.c
+++ b/drivers/video/fbdev/smscufx.c
@@ -1621,7 +1621,7 @@ static int ufx_usb_probe(struct usb_inte
 	struct usb_device *usbdev;
 	struct ufx_data *dev;
 	struct fb_info *info;
-	int retval;
+	int retval = -ENOMEM;
 	u32 id_rev, fpga_rev;
 
 	/* usb initialization */
@@ -1653,15 +1653,17 @@ static int ufx_usb_probe(struct usb_inte
 
 	if (!ufx_alloc_urb_list(dev, WRITES_IN_FLIGHT, MAX_TRANSFER)) {
 		dev_err(dev->gdev, "ufx_alloc_urb_list failed\n");
-		goto e_nomem;
+		goto put_ref;
 	}
 
 	/* We don't register a new USB class. Our client interface is fbdev */
 
 	/* allocates framebuffer driver structure, not framebuffer memory */
 	info = framebuffer_alloc(0, &usbdev->dev);
-	if (!info)
-		goto e_nomem;
+	if (!info) {
+		dev_err(dev->gdev, "framebuffer_alloc failed\n");
+		goto free_urb_list;
+	}
 
 	dev->info = info;
 	info->par = dev;
@@ -1704,22 +1706,34 @@ static int ufx_usb_probe(struct usb_inte
 	check_warn_goto_error(retval, "unable to find common mode for display and adapter");
 
 	retval = ufx_reg_set_bits(dev, 0x4000, 0x00000001);
-	check_warn_goto_error(retval, "error %d enabling graphics engine", retval);
+	if (retval < 0) {
+		dev_err(dev->gdev, "error %d enabling graphics engine", retval);
+		goto setup_modes;
+	}
 
 	/* ready to begin using device */
 	atomic_set(&dev->usb_active, 1);
 
 	dev_dbg(dev->gdev, "checking var");
 	retval = ufx_ops_check_var(&info->var, info);
-	check_warn_goto_error(retval, "error %d ufx_ops_check_var", retval);
+	if (retval < 0) {
+		dev_err(dev->gdev, "error %d ufx_ops_check_var", retval);
+		goto reset_active;
+	}
 
 	dev_dbg(dev->gdev, "setting par");
 	retval = ufx_ops_set_par(info);
-	check_warn_goto_error(retval, "error %d ufx_ops_set_par", retval);
+	if (retval < 0) {
+		dev_err(dev->gdev, "error %d ufx_ops_set_par", retval);
+		goto reset_active;
+	}
 
 	dev_dbg(dev->gdev, "registering framebuffer");
 	retval = register_framebuffer(info);
-	check_warn_goto_error(retval, "error %d register_framebuffer", retval);
+	if (retval < 0) {
+		dev_err(dev->gdev, "error %d register_framebuffer", retval);
+		goto reset_active;
+	}
 
 	dev_info(dev->gdev, "SMSC UDX USB device /dev/fb%d attached. %dx%d resolution."
 		" Using %dK framebuffer memory\n", info->node,
@@ -1727,21 +1741,23 @@ static int ufx_usb_probe(struct usb_inte
 
 	return 0;
 
-error:
-	fb_dealloc_cmap(&info->cmap);
-destroy_modedb:
+reset_active:
+	atomic_set(&dev->usb_active, 0);
+setup_modes:
 	fb_destroy_modedb(info->monspecs.modedb);
 	vfree(info->screen_base);
 	fb_destroy_modelist(&info->modelist);
+error:
+	fb_dealloc_cmap(&info->cmap);
+destroy_modedb:
 	framebuffer_release(info);
+free_urb_list:
+	if (dev->urbs.count > 0)
+		ufx_free_urb_list(dev);
 put_ref:
 	kref_put(&dev->kref, ufx_free); /* ref for framebuffer */
 	kref_put(&dev->kref, ufx_free); /* last ref from kref_init */
 	return retval;
-
-e_nomem:
-	retval = -ENOMEM;
-	goto put_ref;
 }
 
 static void ufx_usb_disconnect(struct usb_interface *interface)


