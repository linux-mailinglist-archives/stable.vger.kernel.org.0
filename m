Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C2843A07A
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235289AbhJYT3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:29:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235492AbhJYT2m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:28:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09C9E60F70;
        Mon, 25 Oct 2021 19:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189905;
        bh=L5gVf7Hcyfcw716rljZqLlsFh1Wz47S0raxIr/2Vc9w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOBX4SMrSxA8JK3fC2qkvl4tOa/h41h5LY6UrX4Fs617vwTHrEcOP4shsTda6Frx+
         +Qfh/aUsW9mBFyrd54PYXPvv0dBWE5yF23+y5hvZzS3H2+yOTM7z0cVut8CywDEIsL
         jEVqyIUl7Qq9rOmhavQJqUD1s1S3fXkoBDnqHHzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com,
        Yanfei Xu <yanfei.xu@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 35/37] net: mdiobus: Fix memory leak in __mdiobus_register
Date:   Mon, 25 Oct 2021 21:15:00 +0200
Message-Id: <20211025190935.477503947@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190926.680827862@linuxfoundation.org>
References: <20211025190926.680827862@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yanfei Xu <yanfei.xu@windriver.com>

commit ab609f25d19858513919369ff3d9a63c02cd9e2e upstream.

Once device_register() failed, we should call put_device() to
decrement reference count for cleanup. Or it will cause memory
leak.

BUG: memory leak
unreferenced object 0xffff888114032e00 (size 256):
  comm "kworker/1:3", pid 2960, jiffies 4294943572 (age 15.920s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 08 2e 03 14 81 88 ff ff  ................
    08 2e 03 14 81 88 ff ff 90 76 65 82 ff ff ff ff  .........ve.....
  backtrace:
    [<ffffffff8265cfab>] kmalloc include/linux/slab.h:591 [inline]
    [<ffffffff8265cfab>] kzalloc include/linux/slab.h:721 [inline]
    [<ffffffff8265cfab>] device_private_init drivers/base/core.c:3203 [inline]
    [<ffffffff8265cfab>] device_add+0x89b/0xdf0 drivers/base/core.c:3253
    [<ffffffff828dd643>] __mdiobus_register+0xc3/0x450 drivers/net/phy/mdio_bus.c:537
    [<ffffffff828cb835>] __devm_mdiobus_register+0x75/0xf0 drivers/net/phy/mdio_devres.c:87
    [<ffffffff82b92a00>] ax88772_init_mdio drivers/net/usb/asix_devices.c:676 [inline]
    [<ffffffff82b92a00>] ax88772_bind+0x330/0x480 drivers/net/usb/asix_devices.c:786
    [<ffffffff82baa33f>] usbnet_probe+0x3ff/0xdf0 drivers/net/usb/usbnet.c:1745
    [<ffffffff82c36e17>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<ffffffff82661d17>] call_driver_probe drivers/base/dd.c:517 [inline]
    [<ffffffff82661d17>] really_probe.part.0+0xe7/0x380 drivers/base/dd.c:596
    [<ffffffff826620bc>] really_probe drivers/base/dd.c:558 [inline]
    [<ffffffff826620bc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826621ba>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff82662a26>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff8265eca7>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826625a2>] __device_attach+0x122/0x260 drivers/base/dd.c:969
    [<ffffffff82660916>] bus_probe_device+0xc6/0xe0 drivers/base/bus.c:487
    [<ffffffff8265cd0b>] device_add+0x5fb/0xdf0 drivers/base/core.c:3359
    [<ffffffff82c343b9>] usb_set_configuration+0x9d9/0xb90 drivers/usb/core/message.c:2170
    [<ffffffff82c4473c>] usb_generic_driver_probe+0x8c/0xc0 drivers/usb/core/generic.c:238

BUG: memory leak
unreferenced object 0xffff888116f06900 (size 32):
  comm "kworker/0:2", pid 2670, jiffies 4294944448 (age 7.160s)
  hex dump (first 32 bytes):
    75 73 62 2d 30 30 31 3a 30 30 33 00 00 00 00 00  usb-001:003.....
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<ffffffff81484516>] kstrdup+0x36/0x70 mm/util.c:60
    [<ffffffff814845a3>] kstrdup_const+0x53/0x80 mm/util.c:83
    [<ffffffff82296ba2>] kvasprintf_const+0xc2/0x110 lib/kasprintf.c:48
    [<ffffffff82358d4b>] kobject_set_name_vargs+0x3b/0xe0 lib/kobject.c:289
    [<ffffffff826575f3>] dev_set_name+0x63/0x90 drivers/base/core.c:3147
    [<ffffffff828dd63b>] __mdiobus_register+0xbb/0x450 drivers/net/phy/mdio_bus.c:535
    [<ffffffff828cb835>] __devm_mdiobus_register+0x75/0xf0 drivers/net/phy/mdio_devres.c:87
    [<ffffffff82b92a00>] ax88772_init_mdio drivers/net/usb/asix_devices.c:676 [inline]
    [<ffffffff82b92a00>] ax88772_bind+0x330/0x480 drivers/net/usb/asix_devices.c:786
    [<ffffffff82baa33f>] usbnet_probe+0x3ff/0xdf0 drivers/net/usb/usbnet.c:1745
    [<ffffffff82c36e17>] usb_probe_interface+0x177/0x370 drivers/usb/core/driver.c:396
    [<ffffffff82661d17>] call_driver_probe drivers/base/dd.c:517 [inline]
    [<ffffffff82661d17>] really_probe.part.0+0xe7/0x380 drivers/base/dd.c:596
    [<ffffffff826620bc>] really_probe drivers/base/dd.c:558 [inline]
    [<ffffffff826620bc>] __driver_probe_device+0x10c/0x1e0 drivers/base/dd.c:751
    [<ffffffff826621ba>] driver_probe_device+0x2a/0x120 drivers/base/dd.c:781
    [<ffffffff82662a26>] __device_attach_driver+0xf6/0x140 drivers/base/dd.c:898
    [<ffffffff8265eca7>] bus_for_each_drv+0xb7/0x100 drivers/base/bus.c:427
    [<ffffffff826625a2>] __device_attach+0x122/0x260 drivers/base/dd.c:969

Reported-by: syzbot+398e7dc692ddbbb4cfec@syzkaller.appspotmail.com
Signed-off-by: Yanfei Xu <yanfei.xu@windriver.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mdio_bus.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -388,6 +388,7 @@ int __mdiobus_register(struct mii_bus *b
 	err = device_register(&bus->dev);
 	if (err) {
 		pr_err("mii_bus %s failed to register\n", bus->id);
+		put_device(&bus->dev);
 		return -EINVAL;
 	}
 


