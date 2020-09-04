Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE9525D196
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 08:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbgIDGjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 02:39:11 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10811 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726251AbgIDGjL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 02:39:11 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A6DF026C41212103A2AA;
        Fri,  4 Sep 2020 14:39:05 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Fri, 4 Sep 2020 14:38:59 +0800
From:   Zeng Tao <prime.zeng@hisilicon.com>
To:     <gregkh@linuxfoundation.org>
CC:     Zeng Tao <prime.zeng@hisilicon.com>,
        stable <stable@vger.kernel.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        chenqiwu <chenqiwu@xiaomi.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: core: fix slab-out-of-bounds Read in read_descriptors
Date:   Fri, 4 Sep 2020 14:37:44 +0800
Message-ID: <1599201467-11000-1-git-send-email-prime.zeng@hisilicon.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The USB device descriptor may get changed between two consecutive
enumerations on the same device for some reason, such as DFU or
malicius device.
In that case, we may access the changing descriptor if we don't take
the device lock here.

The issue is reported:
https://syzkaller.appspot.com/bug?id=901a0d9e6519ef8dc7acab25344bd287dd3c7be9

Cc: stable <stable@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Reported-by: syzbot+256e56ddde8b8957eabd@syzkaller.appspotmail.com
Fixes: 217a9081d8e6 ("USB: add all configs to the "descriptors" attribute")
Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>
---
 drivers/usb/core/sysfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index a2ca38e..8d13419 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -889,7 +889,11 @@ read_descriptors(struct file *filp, struct kobject *kobj,
 	size_t srclen, n;
 	int cfgno;
 	void *src;
+	int retval;
 
+	retval = usb_lock_device_interruptible(udev);
+	if (retval < 0)
+		return -EINTR;
 	/* The binary attribute begins with the device descriptor.
 	 * Following that are the raw descriptor entries for all the
 	 * configurations (config plus subsidiary descriptors).
@@ -914,6 +918,7 @@ read_descriptors(struct file *filp, struct kobject *kobj,
 			off -= srclen;
 		}
 	}
+	usb_unlock_device(udev);
 	return count - nleft;
 }
 
-- 
2.8.1

