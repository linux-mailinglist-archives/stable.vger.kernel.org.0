Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A291323D26
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:07:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbhBXNE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:54428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235608AbhBXM7D (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:59:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5C1064F0B;
        Wed, 24 Feb 2021 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171159;
        bh=MujD0LlhJccQMLu8B5pHIBrjM6vOnk8ruXzVCvlOZLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qPbcDNOvD0Fl82zcgbO4kx1eiv5rxTxwmkQM4Gz2to/TUs+w0A3nm7UjU82r2xe0E
         UXX53h8nsBIvZtsAvUcXmtn+yjxbZ6KNcggHLQWPIjbZ8Fe0GBK4r9nuF2INGp8Q/M
         ZWKm2Zjmnnhz9pjgmlrJbWE/EvaG1i2lYeazdFt7y9MtARlpElIDuf8739GdTxjTXf
         wO/1/FzYoY7EqT61EdAna68N+it5o+xC3szoKpG4HW13SEh7sKqyzP0QCmuH8srxYt
         TQmSEj61U8Z9JvfX/qmlHdP4QliqI93xd4Kxu2KW+v8gj0nwW/HHHeQbvFxG/gsX+B
         4jHVJEAE3EMjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zqiang <qiang.zhang@windriver.com>,
        syzbot+c9e365d7f450e8aa615d@syzkaller.appspotmail.com,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 20/56] udlfb: Fix memory leak in dlfb_usb_probe
Date:   Wed, 24 Feb 2021 07:51:36 -0500
Message-Id: <20210224125212.482485-20-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
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
index f9b3c1cb9530f..b9cdd02c10009 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -1017,6 +1017,7 @@ static void dlfb_ops_destroy(struct fb_info *info)
 	}
 	vfree(dlfb->backing_buffer);
 	kfree(dlfb->edid);
+	dlfb_free_urb_list(dlfb);
 	usb_put_dev(dlfb->udev);
 	kfree(dlfb);
 
-- 
2.27.0

