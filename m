Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0063BA68D
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405166AbfIVSvZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:51:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405028AbfIVSvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:51:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DABD321D7A;
        Sun, 22 Sep 2019 18:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178283;
        bh=TEEH8AkXj/LBWnxOt8qCA4YMnQ7RsOpFc05KlNuJSCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nH/BwzN9zB/NQYHvNwjBve3P0ebqIW3fQ+Zq1mMnxP6FpVBSgdMBblyDI4gndtP+7
         3Xt7npXqRsQpneRn+bRPEEcfLPcvWfJ45MWFBsH/WSyZ531Df0I58/j+dpFVqCYPDt
         GUqdmpdcZXXxyTWXXVtPlwL0wSvNo5WLY+D7rd2c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Young <sean@mess.org>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Brad Love <brad@nextdimension.cc>,
        syzbot+b7f57261c521087d89bb@syzkaller.appspotmail.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 064/185] media: em28xx: modules workqueue not inited for 2nd device
Date:   Sun, 22 Sep 2019 14:47:22 -0400
Message-Id: <20190922184924.32534-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

[ Upstream commit 46e4a26615cc7854340e4b69ca59ee78d6f20c8b ]

syzbot reports an error on flush_request_modules() for the second device.
This workqueue was never initialised so simply remove the offending line.

usb 1-1: USB disconnect, device number 2
em28xx 1-1:1.153: Disconnecting em28xx #1
------------[ cut here ]------------
WARNING: CPU: 0 PID: 12 at kernel/workqueue.c:3031
__flush_work.cold+0x2c/0x36 kernel/workqueue.c:3031
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.3.0-rc2+ #25
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  panic+0x2a3/0x6da kernel/panic.c:219
  __warn.cold+0x20/0x4a kernel/panic.c:576
  report_bug+0x262/0x2a0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:179 [inline]
  fixup_bug arch/x86/kernel/traps.c:174 [inline]
  do_error_trap+0x12b/0x1e0 arch/x86/kernel/traps.c:272
  do_invalid_op+0x32/0x40 arch/x86/kernel/traps.c:291
  invalid_op+0x23/0x30 arch/x86/entry/entry_64.S:1026
RIP: 0010:__flush_work.cold+0x2c/0x36 kernel/workqueue.c:3031
Code: 9a 22 00 48 c7 c7 20 e4 c5 85 e8 d9 3a 0d 00 0f 0b 45 31 e4 e9 98 86
ff ff e8 51 9a 22 00 48 c7 c7 20 e4 c5 85 e8 be 3a 0d 00 <0f> 0b 45 31 e4
e9 7d 86 ff ff e8 36 9a 22 00 48 c7 c7 20 e4 c5 85
RSP: 0018:ffff8881da20f720 EFLAGS: 00010286
RAX: 0000000000000024 RBX: dffffc0000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff8128a0fd RDI: ffffed103b441ed6
RBP: ffff8881da20f888 R08: 0000000000000024 R09: fffffbfff11acd9a
R10: fffffbfff11acd99 R11: ffffffff88d66ccf R12: 0000000000000000
R13: 0000000000000001 R14: ffff8881c6685df8 R15: ffff8881d2a85b78
  flush_request_modules drivers/media/usb/em28xx/em28xx-cards.c:3325 [inline]
  em28xx_usb_disconnect.cold+0x280/0x2a6
drivers/media/usb/em28xx/em28xx-cards.c:4023
  usb_unbind_interface+0x1bd/0x8a0 drivers/usb/core/driver.c:423
  __device_release_driver drivers/base/dd.c:1120 [inline]
  device_release_driver_internal+0x404/0x4c0 drivers/base/dd.c:1151
  bus_remove_device+0x2dc/0x4a0 drivers/base/bus.c:556
  device_del+0x420/0xb10 drivers/base/core.c:2288
  usb_disable_device+0x211/0x690 drivers/usb/core/message.c:1237
  usb_disconnect+0x284/0x8d0 drivers/usb/core/hub.c:2199
  hub_port_connect drivers/usb/core/hub.c:4949 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5213 [inline]
  port_event drivers/usb/core/hub.c:5359 [inline]
  hub_event+0x1454/0x3640 drivers/usb/core/hub.c:5441
  process_one_work+0x92b/0x1530 kernel/workqueue.c:2269
  process_scheduled_works kernel/workqueue.c:2331 [inline]
  worker_thread+0x7ab/0xe20 kernel/workqueue.c:2417
  kthread+0x318/0x420 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Kernel Offset: disabled
Rebooting in 86400 seconds..

Fixes: be7fd3c3a8c5e ("media: em28xx: Hauppauge DualHD second tuner functionality)
Reviewed-by: Ezequiel Garcia <ezequiel@collabora.com>
Reviewed-by: Brad Love <brad@nextdimension.cc>
Reported-by: syzbot+b7f57261c521087d89bb@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 1283c7ca9ad51..1de835a591a06 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -4020,7 +4020,6 @@ static void em28xx_usb_disconnect(struct usb_interface *intf)
 		dev->dev_next->disconnected = 1;
 		dev_info(&dev->intf->dev, "Disconnecting %s\n",
 			 dev->dev_next->name);
-		flush_request_modules(dev->dev_next);
 	}
 
 	dev->disconnected = 1;
-- 
2.20.1

