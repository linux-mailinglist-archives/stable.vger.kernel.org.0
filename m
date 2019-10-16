Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB97DDA0A4
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439328AbfJPWNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395361AbfJPVzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:55:46 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44F84218DE;
        Wed, 16 Oct 2019 21:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262946;
        bh=USWBleXjwXnXwcBWIYOfCKkr4PGVJwm1DSVGRna6F04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1kjl2M4hmWQHl+Q2qkPdTHx53HUpzVqn+rskLUNZMGTRAcCxj1xKpLs8l4Uog3Qr
         yscJKOgrUb7PJtJoc7N3D02qlqD/Zo1PTjyu9AZZZRsCWPy9bzmLSVXNZVklklnFe2
         2UKmK+Zpaf6LvulQyj47554blJSrsx2SlgQ4P31c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+0761012cebf7bdb38137@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.14 17/65] USB: iowarrior: fix use-after-free on disconnect
Date:   Wed, 16 Oct 2019 14:50:31 -0700
Message-Id: <20191016214810.223397885@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214756.457746573@linuxfoundation.org>
References: <20191016214756.457746573@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit edc4746f253d907d048de680a621e121517f484b upstream.

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

---
 drivers/usb/misc/iowarrior.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -870,8 +870,6 @@ static void iowarrior_disconnect(struct
 	dev = usb_get_intfdata(interface);
 	mutex_lock(&iowarrior_open_disc_lock);
 	usb_set_intfdata(interface, NULL);
-	/* prevent device read, write and ioctl */
-	dev->present = 0;
 
 	minor = dev->minor;
 	mutex_unlock(&iowarrior_open_disc_lock);
@@ -882,8 +880,7 @@ static void iowarrior_disconnect(struct
 	mutex_lock(&dev->mutex);
 
 	/* prevent device read, write and ioctl */
-
-	mutex_unlock(&dev->mutex);
+	dev->present = 0;
 
 	if (dev->opened) {
 		/* There is a process that holds a filedescriptor to the device ,
@@ -893,8 +890,10 @@ static void iowarrior_disconnect(struct
 		usb_kill_urb(dev->int_in_urb);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
+		mutex_unlock(&dev->mutex);
 	} else {
 		/* no process is using the device, cleanup now */
+		mutex_unlock(&dev->mutex);
 		iowarrior_delete(dev);
 	}
 


