Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE9A104C43
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 08:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKUHTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 02:19:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfKUHTp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 02:19:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B53020872;
        Thu, 21 Nov 2019 07:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574320784;
        bh=EtOqhbUd+cBjPJLUPZqGLf3eKGblDJ13tYq8uP2Ve0s=;
        h=Subject:To:From:Date:From;
        b=zcBxVaZGYN9cdWj4ZXUecfQWYwKf1dS2xaHRpiRqId9rC5+C81VkLCUMwATL/Tutz
         P5TBvrKsHtSDzwVV85mlu32UjG8k2ybIdL/8ERqpBxqvqERPtpHhU2HAy9/4V6yvUd
         6j/AVjJ0Agn1xAwl1W6k0+d9WP89P0Ygvys+z4Ew=
Subject: patch "usb: gadget: configfs: Fix missing spin_lock_init()" added to usb-next
To:     weiyongjun1@huawei.com, gregkh@linuxfoundation.org,
        peter.chen@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 21 Nov 2019 08:19:34 +0100
Message-ID: <1574320774163229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: configfs: Fix missing spin_lock_init()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 093edc2baad2c258b1f55d1ab9c63c2b5ae67e42 Mon Sep 17 00:00:00 2001
From: Wei Yongjun <weiyongjun1@huawei.com>
Date: Wed, 30 Oct 2019 03:40:46 +0000
Subject: usb: gadget: configfs: Fix missing spin_lock_init()

The driver allocates the spinlock but not initialize it.
Use spin_lock_init() on it to initialize it correctly.

This is detected by Coccinelle semantic patch.

Fixes: 1a1c851bbd70 ("usb: gadget: configfs: fix concurrent issue between composite APIs")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Link: https://lore.kernel.org/r/20191030034046.188808-1-weiyongjun1@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 33852c2b29d1..ab9ac48a751a 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1544,6 +1544,7 @@ static struct config_group *gadgets_make(
 	gi->composite.resume = NULL;
 	gi->composite.max_speed = USB_SPEED_SUPER;
 
+	spin_lock_init(&gi->spinlock);
 	mutex_init(&gi->lock);
 	INIT_LIST_HEAD(&gi->string_list);
 	INIT_LIST_HEAD(&gi->available_func);
-- 
2.24.0


