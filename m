Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8753511AB04
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 13:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbfLKMet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 07:34:49 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60680 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727457AbfLKMet (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 07:34:49 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 93962202431A433A9983;
        Wed, 11 Dec 2019 20:34:47 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Dec 2019 20:34:39 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <kernel.openeuler@huawei.com>
CC:     Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>,
        <syzbot+0761012cebf7bdb38137@syzkaller.appspotmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH rh7.3 07/11] USB: iowarrior: fix use-after-free on disconnect
Date:   Wed, 11 Dec 2019 20:31:50 +0800
Message-ID: <20191211123154.141040-8-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211123154.141040-1-maowenan@huawei.com>
References: <20191211123154.141040-1-maowenan@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

mainline inclusion
from mainline-5.4
commit edc4746f253d907d048de680a621e121517f484b
category: bugfix
bugzilla: NA
DTS: NA
CVE: CVE-2019-19528

-------------------------------------------------

A recent fix addressing a deadlock on disconnect introduced a new bug
by moving the present flag out of the critical section protected by the
driver-data mutex. This could lead to a racing release() freeing the
driver data before disconnect() is done with it.

Due to insufficient locking a related use-after-free could be triggered
also before the above mentioned commit. Specifically, the driver needs
to hold the driver-data mutex also while checking the opened flag at
disconnect().

Fixes: c468a8aa790e ("usb: iowarrior: fix deadlock on disconnect")
Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Cc: stable <stable@vger.kernel.org>	# 2.6.21
Reported-by: syzbot+0761012cebf7bdb38137@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009104846.5925-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/usb/misc/iowarrior.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index eb8c08a54a77..7844fd957a8d 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -889,8 +889,6 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 	dev = usb_get_intfdata(interface);
 	mutex_lock(&iowarrior_open_disc_lock);
 	usb_set_intfdata(interface, NULL);
-	/* prevent device read, write and ioctl */
-	dev->present = 0;
 
 	minor = dev->minor;
 	mutex_unlock(&iowarrior_open_disc_lock);
@@ -901,8 +899,7 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 	mutex_lock(&dev->mutex);
 
 	/* prevent device read, write and ioctl */
-
-	mutex_unlock(&dev->mutex);
+	dev->present = 0;
 
 	if (dev->opened) {
 		/* There is a process that holds a filedescriptor to the device ,
@@ -912,8 +909,10 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 		usb_kill_urb(dev->int_in_urb);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
+		mutex_unlock(&dev->mutex);
 	} else {
 		/* no process is using the device, cleanup now */
+		mutex_unlock(&dev->mutex);
 		iowarrior_delete(dev);
 	}
 
-- 
2.20.1

