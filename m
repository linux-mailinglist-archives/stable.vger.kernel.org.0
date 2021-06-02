Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C24398952
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 14:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhFBMWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 08:22:18 -0400
Received: from www.linuxtv.org ([130.149.80.248]:46870 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229665AbhFBMWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Jun 2021 08:22:13 -0400
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1loPrH-00GFAU-1v; Wed, 02 Jun 2021 12:20:27 +0000
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date:   Wed, 02 Jun 2021 11:35:15 +0000
Subject: [git:media_stage/master] media: zr364xx: fix memory leak in zr364xx_start_readpipe
To:     linuxtv-commits@linuxtv.org
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1loPrH-00GFAU-1v@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: zr364xx: fix memory leak in zr364xx_start_readpipe
Author:  Pavel Skripkin <paskripkin@gmail.com>
Date:    Mon May 17 21:18:14 2021 +0200

syzbot reported memory leak in zr364xx driver.
The problem was in non-freed urb in case of
usb_submit_urb() fail.

backtrace:
  [<ffffffff82baedf6>] kmalloc include/linux/slab.h:561 [inline]
  [<ffffffff82baedf6>] usb_alloc_urb+0x66/0xe0 drivers/usb/core/urb.c:74
  [<ffffffff82f7cce8>] zr364xx_start_readpipe+0x78/0x130 drivers/media/usb/zr364xx/zr364xx.c:1022
  [<ffffffff84251dfc>] zr364xx_board_init drivers/media/usb/zr364xx/zr364xx.c:1383 [inline]
  [<ffffffff84251dfc>] zr364xx_probe+0x6a3/0x851 drivers/media/usb/zr364xx/zr364xx.c:1516
  [<ffffffff82bb6507>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
  [<ffffffff826018a9>] really_probe+0x159/0x500 drivers/base/dd.c:576

Fixes: ccbf035ae5de ("V4L/DVB (12278): zr364xx: implement V4L2_CAP_STREAMING")
Cc: stable@vger.kernel.org
Reported-by: syzbot+af4fa391ef18efdd5f69@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

 drivers/media/usb/zr364xx/zr364xx.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index 1ef611e08323..538a330046ec 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -1032,6 +1032,7 @@ static int zr364xx_start_readpipe(struct zr364xx_camera *cam)
 	DBG("submitting URB %p\n", pipe_info->stream_urb);
 	retval = usb_submit_urb(pipe_info->stream_urb, GFP_KERNEL);
 	if (retval) {
+		usb_free_urb(pipe_info->stream_urb);
 		printk(KERN_ERR KBUILD_MODNAME ": start read pipe failed\n");
 		return retval;
 	}
