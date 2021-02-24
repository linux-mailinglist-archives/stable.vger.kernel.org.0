Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91F4323DD5
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbhBXNTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:19:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:58412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236027AbhBXNIh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 08:08:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 005DA64F97;
        Wed, 24 Feb 2021 12:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171289;
        bh=EYRaWi8blV+9ujZEjSsC41wqYz+mU0lCnju3XoBnxrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N8LxvnMWZREQJhw9l26gWWQW56myZLkztc3Mj+NVc88C/73BunGQN9svQRVVMtXVr
         HjQ2H+23QaP1bpEEC+47JfZ2BER6h/iK9dzdb7QOEGjiOGcz0xIEd6Xr2kNCoXReFG
         p8kfI3CFhwmUaPHVcd9Q9nbVjaIsGabXbnv4Duhb2DkhCpo+YNGsRCZjuMlmQ7Zr1l
         gUXZvATAKpwsv5WQ6FRNMsFDT243vs4ifceQvhYi5dGN2Ao2JcJztbb7KDc30PGyOr
         35nU4puuhwvZWCIs89vY2jDXlTraoYuYXpVIdepDinZfte2ZwgMl9EXt141keJ1JHs
         T2jviTJZxjeOw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang.zhang@windriver.com>,
        syzbot+c9e365d7f450e8aa615d@syzkaller.appspotmail.com,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 11/26] udlfb: Fix memory leak in dlfb_usb_probe
Date:   Wed, 24 Feb 2021 07:54:19 -0500
Message-Id: <20210224125435.483539-11-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125435.483539-1-sashal@kernel.org>
References: <20210224125435.483539-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zqiang <qiang.zhang@windriver.com>

[ Upstream commit 5c0e4110f751934e748a66887c61f8e73805f0f9 ]

The dlfb_alloc_urb_list function is called in dlfb_usb_probe function,
after that if an error occurs, the dlfb_free_urb_list function need to
be called.

BUG: memory leak
unreferenced object 0xffff88810adde100 (size 32):
  comm "kworker/1:0", pid 17, jiffies 4294947788 (age 19.520s)
  hex dump (first 32 bytes):
    10 30 c3 0d 81 88 ff ff c0 fa 63 12 81 88 ff ff  .0........c.....
    00 30 c3 0d 81 88 ff ff 80 d1 3a 08 81 88 ff ff  .0........:.....
  backtrace:
    [<0000000019512953>] kmalloc include/linux/slab.h:552 [inline]
    [<0000000019512953>] kzalloc include/linux/slab.h:664 [inline]
    [<0000000019512953>] dlfb_alloc_urb_list drivers/video/fbdev/udlfb.c:1892 [inline]
    [<0000000019512953>] dlfb_usb_probe.cold+0x289/0x988 drivers/video/fbdev/udlfb.c:1704
    [<0000000072160152>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<00000000a8d6726f>] really_probe+0x159/0x480 drivers/base/dd.c:554
    [<00000000c3ce4b0e>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
    [<00000000e942e01c>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844
    [<00000000de0a5a5c>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431
    [<00000000463fbcb4>] __device_attach+0x122/0x250 drivers/base/dd.c:912
    [<00000000b881a711>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:491
    [<00000000364bbda5>] device_add+0x5ac/0xc30 drivers/base/core.c:2936
    [<00000000eecca418>] usb_set_configuration+0x9de/0xb90 drivers/usb/core/message.c:2159
    [<00000000edfeca2d>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238
    [<000000001830872b>] usb_probe_device+0x5c/0x140 drivers/usb/core/driver.c:293
    [<00000000a8d6726f>] really_probe+0x159/0x480 drivers/base/dd.c:554
    [<00000000c3ce4b0e>] driver_probe_device+0x84/0x100 drivers/base/dd.c:738
    [<00000000e942e01c>] __device_attach_driver+0xee/0x110 drivers/base/dd.c:844
    [<00000000de0a5a5c>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:431

Reported-by: syzbot+c9e365d7f450e8aa615d@syzkaller.appspotmail.com
Signed-off-by: Zqiang <qiang.zhang@windriver.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20201215063022.16746-1-qiang.zhang@windriver.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/udlfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 5a0d6fb02bbc5..f7823aa99340d 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1020,6 +1020,7 @@ static void dlfb_ops_destroy(struct fb_info *info)
 	}
 	vfree(dlfb->backing_buffer);
 	kfree(dlfb->edid);
+	dlfb_free_urb_list(dlfb);
 	usb_put_dev(dlfb->udev);
 	kfree(dlfb);
 
-- 
2.27.0

