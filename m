Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 087247F3FF
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 12:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405130AbfHBKCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 06:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392168AbfHBJn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:43:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F97B20679;
        Fri,  2 Aug 2019 09:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739007;
        bh=vr8sUQAGvlVd+c77Ps88j+tC2L6YuF6u7hZIZfcEnCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NMfbzwtpA4nFeNtK2n/3Z3fckhNTtfi72Y/xFB1TJPY0hTEvd9xco5HZWnMvhaSFY
         ZAxwuO8XLWHpyZfQec5bVYPvc6cD9WVVtqlXj5DnGUGJtmrUoW/HszrtQiRcMgDekh
         nS4EV7pYsvzEJbnudfAM0Pa/mAZT+c0kflpnFRqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8a3fc6674bbc3978ed4e@syzkaller.appspotmail.com,
        Phong Tran <tranmanphong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 066/223] net: usb: asix: init MAC address buffers
Date:   Fri,  2 Aug 2019 11:34:51 +0200
Message-Id: <20190802092243.107505264@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 78226f6eaac80bf30256a33a4926c194ceefdf36 ]

This is for fixing bug KMSAN: uninit-value in ax88772_bind

Tested by
https://groups.google.com/d/msg/syzkaller-bugs/aFQurGotng4/eB_HlNhhCwAJ

Reported-by: syzbot+8a3fc6674bbc3978ed4e@syzkaller.appspotmail.com

syzbot found the following crash on:

HEAD commit:    f75e4cfe kmsan: use kmsan_handle_urb() in urb.c
git tree:       kmsan
console output: https://syzkaller.appspot.com/x/log.txt?x=136d720ea00000
kernel config:
https://syzkaller.appspot.com/x/.config?x=602468164ccdc30a
dashboard link:
https://syzkaller.appspot.com/bug?extid=8a3fc6674bbc3978ed4e
compiler:       clang version 9.0.0 (/home/glider/llvm/clang
06d00afa61eef8f7f501ebdb4e8612ea43ec2d78)
syz repro:
https://syzkaller.appspot.com/x/repro.syz?x=12788316a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=120359aaa00000

==================================================================
BUG: KMSAN: uninit-value in is_valid_ether_addr
include/linux/etherdevice.h:200 [inline]
BUG: KMSAN: uninit-value in asix_set_netdev_dev_addr
drivers/net/usb/asix_devices.c:73 [inline]
BUG: KMSAN: uninit-value in ax88772_bind+0x93d/0x11e0
drivers/net/usb/asix_devices.c:724
CPU: 0 PID: 3348 Comm: kworker/0:2 Not tainted 5.1.0+ #1
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
Google 01/01/2011
Workqueue: usb_hub_wq hub_event
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x191/0x1f0 lib/dump_stack.c:113
  kmsan_report+0x130/0x2a0 mm/kmsan/kmsan.c:622
  __msan_warning+0x75/0xe0 mm/kmsan/kmsan_instr.c:310
  is_valid_ether_addr include/linux/etherdevice.h:200 [inline]
  asix_set_netdev_dev_addr drivers/net/usb/asix_devices.c:73 [inline]
  ax88772_bind+0x93d/0x11e0 drivers/net/usb/asix_devices.c:724
  usbnet_probe+0x10f5/0x3940 drivers/net/usb/usbnet.c:1728
  usb_probe_interface+0xd66/0x1320 drivers/usb/core/driver.c:361
  really_probe+0xdae/0x1d80 drivers/base/dd.c:513
  driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x454/0x730 drivers/base/dd.c:844
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
  bus_probe_device+0x137/0x390 drivers/base/bus.c:514
  device_add+0x288d/0x30e0 drivers/base/core.c:2106
  usb_set_configuration+0x30dc/0x3750 drivers/usb/core/message.c:2027
  generic_probe+0xe7/0x280 drivers/usb/core/generic.c:210
  usb_probe_device+0x14c/0x200 drivers/usb/core/driver.c:266
  really_probe+0xdae/0x1d80 drivers/base/dd.c:513
  driver_probe_device+0x1b3/0x4f0 drivers/base/dd.c:671
  __device_attach_driver+0x5b8/0x790 drivers/base/dd.c:778
  bus_for_each_drv+0x28e/0x3b0 drivers/base/bus.c:454
  __device_attach+0x454/0x730 drivers/base/dd.c:844
  device_initial_probe+0x4a/0x60 drivers/base/dd.c:891
  bus_probe_device+0x137/0x390 drivers/base/bus.c:514
  device_add+0x288d/0x30e0 drivers/base/core.c:2106
  usb_new_device+0x23e5/0x2ff0 drivers/usb/core/hub.c:2534
  hub_port_connect drivers/usb/core/hub.c:5089 [inline]
  hub_port_connect_change drivers/usb/core/hub.c:5204 [inline]
  port_event drivers/usb/core/hub.c:5350 [inline]
  hub_event+0x48d1/0x7290 drivers/usb/core/hub.c:5432
  process_one_work+0x1572/0x1f00 kernel/workqueue.c:2269
  process_scheduled_works kernel/workqueue.c:2331 [inline]
  worker_thread+0x189c/0x2460 kernel/workqueue.c:2417
  kthread+0x4b5/0x4f0 kernel/kthread.c:254
  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:355

Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/asix_devices.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
index 393fd3ed6b94..4b12b6da3fab 100644
--- a/drivers/net/usb/asix_devices.c
+++ b/drivers/net/usb/asix_devices.c
@@ -237,7 +237,7 @@ static void asix_phy_reset(struct usbnet *dev, unsigned int reset_bits)
 static int ax88172_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int ret = 0;
-	u8 buf[ETH_ALEN];
+	u8 buf[ETH_ALEN] = {0};
 	int i;
 	unsigned long gpio_bits = dev->driver_info->data;
 
@@ -687,7 +687,7 @@ static int asix_resume(struct usb_interface *intf)
 static int ax88772_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int ret, i;
-	u8 buf[ETH_ALEN], chipcode = 0;
+	u8 buf[ETH_ALEN] = {0}, chipcode = 0;
 	u32 phyid;
 	struct asix_common_private *priv;
 
@@ -1064,7 +1064,7 @@ static const struct net_device_ops ax88178_netdev_ops = {
 static int ax88178_bind(struct usbnet *dev, struct usb_interface *intf)
 {
 	int ret;
-	u8 buf[ETH_ALEN];
+	u8 buf[ETH_ALEN] = {0};
 
 	usbnet_get_endpoints(dev,intf);
 
-- 
2.20.1



