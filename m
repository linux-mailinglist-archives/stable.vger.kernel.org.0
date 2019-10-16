Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB79D9DD6
	for <lists+stable@lfdr.de>; Wed, 16 Oct 2019 23:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394940AbfJPVx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:53:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394933AbfJPVx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:53:58 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08FD721D7A;
        Wed, 16 Oct 2019 21:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571262838;
        bh=QsOC5gohWhKu68x3DEK4fIwmbT7ZiSvW2vWkbWuQVeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YXyRYnPDDwFrc5Wd4h/IPxkrTO0t20uVyx/qVFpdfqa47SomfxYBWCCWkMSViXeur
         UsQ2ZpAxkGpp4jIEbEnYZuV9BvnOF3UTeusnoLzRzBBFUj1s5QskjhAuiYNmp+fp0U
         gFS3NltEYOFATOHegwnZYRtAxL24a2UkTVIYS6lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.4 43/79] USB: iowarrior: fix use-after-free on release
Date:   Wed, 16 Oct 2019 14:50:18 -0700
Message-Id: <20191016214805.448643299@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
References: <20191016214729.758892904@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 80cd5479b525093a56ef768553045741af61b250 upstream.

The driver was accessing its struct usb_interface from its release()
callback without holding a reference. This would lead to a
use-after-free whenever debugging was enabled and the device was
disconnected while its character device was open.

Fixes: 549e83500b80 ("USB: iowarrior: Convert local dbg macro to dev_dbg")
Cc: stable <stable@vger.kernel.org>     # 3.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191009104846.5925-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/iowarrior.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -248,6 +248,7 @@ static inline void iowarrior_delete(stru
 	kfree(dev->int_in_buffer);
 	usb_free_urb(dev->int_in_urb);
 	kfree(dev->read_queue);
+	usb_put_intf(dev->interface);
 	kfree(dev);
 }
 
@@ -782,7 +783,7 @@ static int iowarrior_probe(struct usb_in
 	init_waitqueue_head(&dev->write_wait);
 
 	dev->udev = udev;
-	dev->interface = interface;
+	dev->interface = usb_get_intf(interface);
 
 	iface_desc = interface->cur_altsetting;
 	dev->product_id = le16_to_cpu(udev->descriptor.idProduct);


