Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944C011AB06
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 13:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729244AbfLKMev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 07:34:51 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:60686 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729211AbfLKMev (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 07:34:51 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 998D4EEBF4674DAB14F7;
        Wed, 11 Dec 2019 20:34:47 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 11 Dec 2019 20:34:38 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <kernel.openeuler@huawei.com>
CC:     Oliver Neukum <oneukum@suse.com>,
        <syzbot+a64a382964bf6c71a9c0@syzkaller.appspotmail.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH rh7.3 06/11] usb: iowarrior: fix deadlock on disconnect
Date:   Wed, 11 Dec 2019 20:31:49 +0800
Message-ID: <20191211123154.141040-7-maowenan@huawei.com>
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

From: Oliver Neukum <oneukum@suse.com>

mainline inclusion
from mainline-5.3
commit c468a8aa790e0dfe0a7f8a39db282d39c2c00b46
category: bugfix
bugzilla: NA
DTS: NA
CVE: CVE-2019-19528

-------------------------------------------------

We have to drop the mutex before we close() upon disconnect()
as close() needs the lock. This is safe to do by dropping the
mutex as intfdata is already set to NULL, so open() will fail.

Fixes: 03f36e885fc26 ("USB: open disconnect race in iowarrior")
Reported-by: syzbot+a64a382964bf6c71a9c0@syzkaller.appspotmail.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20190808092728.23417-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/usb/misc/iowarrior.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index 1950e87b4219..eb8c08a54a77 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -889,19 +889,20 @@ static void iowarrior_disconnect(struct usb_interface *interface)
 	dev = usb_get_intfdata(interface);
 	mutex_lock(&iowarrior_open_disc_lock);
 	usb_set_intfdata(interface, NULL);
+	/* prevent device read, write and ioctl */
+	dev->present = 0;
 
 	minor = dev->minor;
+	mutex_unlock(&iowarrior_open_disc_lock);
+	/* give back our minor - this will call close() locks need to be dropped at this point*/
 
-	/* give back our minor */
 	usb_deregister_dev(interface, &iowarrior_class);
 
 	mutex_lock(&dev->mutex);
 
 	/* prevent device read, write and ioctl */
-	dev->present = 0;
 
 	mutex_unlock(&dev->mutex);
-	mutex_unlock(&iowarrior_open_disc_lock);
 
 	if (dev->opened) {
 		/* There is a process that holds a filedescriptor to the device ,
-- 
2.20.1

