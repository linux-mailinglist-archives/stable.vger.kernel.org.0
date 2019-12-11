Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F63511AB05
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 13:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfLKMeu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 07:34:50 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60596 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729228AbfLKMeu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 07:34:50 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7242470E316FDC392340;
        Wed, 11 Dec 2019 20:34:47 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Dec 2019 20:34:38 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <kernel.openeuler@huawei.com>
CC:     Johan Hovold <johan@kernel.org>, stable <stable@vger.kernel.org>,
        <syzbot+0243cb250a51eeefb8cc@syzkaller.appspotmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH rh7.3 05/11] USB: adutux: fix use-after-free on disconnect
Date:   Wed, 11 Dec 2019 20:31:48 +0800
Message-ID: <20191211123154.141040-6-maowenan@huawei.com>
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
commit 44efc269db7929f6275a1fa927ef082e533ecde0
category: bugfix
bugzilla: NA
DTS: NA
CVE: CVE-2019-19523

-------------------------------------------------

The driver was clearing its struct usb_device pointer, which it used as
an inverted disconnected flag, before deregistering the character device
and without serialising against racing release().

This could lead to a use-after-free if a racing release() callback
observes the cleared pointer and frees the driver data before
disconnect() is finished with it.

This could also lead to NULL-pointer dereferences in a racing open().

Fixes: f08812d5eb8f ("USB: FIx locks and urb->status in adutux (updated)")
Cc: stable <stable@vger.kernel.org>     # 2.6.24
Reported-by: syzbot+0243cb250a51eeefb8cc@syzkaller.appspotmail.com
Tested-by: syzbot+0243cb250a51eeefb8cc@syzkaller.appspotmail.com
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20190925092913.8608-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/usb/misc/adutux.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/adutux.c b/drivers/usb/misc/adutux.c
index 3071c0ef909b..2f308f5a415b 100644
--- a/drivers/usb/misc/adutux.c
+++ b/drivers/usb/misc/adutux.c
@@ -804,15 +804,16 @@ static void adu_disconnect(struct usb_interface *interface)
 
 	dev = usb_get_intfdata(interface);
 
-	mutex_lock(&dev->mtx);	/* not interruptible */
-	dev->udev = NULL;	/* poison */
 	minor = dev->minor;
 	usb_deregister_dev(interface, &adu_class);
-	mutex_unlock(&dev->mtx);
 
 	mutex_lock(&adutux_mutex);
 	usb_set_intfdata(interface, NULL);
 
+	mutex_lock(&dev->mtx);	/* not interruptible */
+	dev->udev = NULL;	/* poison */
+	mutex_unlock(&dev->mtx);
+
 	/* if the device is not opened, then we clean up right now */
 	if (!dev->open_count)
 		adu_delete(dev);
-- 
2.20.1

