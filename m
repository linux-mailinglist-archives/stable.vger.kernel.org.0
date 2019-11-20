Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE3310448C
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 20:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfKTTtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 14:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbfKTTtD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Nov 2019 14:49:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4341C20679;
        Wed, 20 Nov 2019 19:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574279342;
        bh=4Yylve0XKqwFQhuvCSg6udFvsnwxRrhTvVcTVcXMVhM=;
        h=Subject:To:From:Date:From;
        b=lWfMSqU7iTNHovNREiemZiaYvgBvcTLHUZ9AEqDJd3L3fRV93goR+CbrD2rgwIrez
         0fmWVzLxDJ9zLDov9U/Vue1PJ8/bzh5uOq+8SpYObO7/y2WyEPDLhSZTCh5pXdbvh6
         qx8ML5kvSaEN9xhqqRqdC+VGih34iPsNsN/3TJcU=
Subject: patch "usb: gadget: configfs: Fix missing spin_lock_init()" added to usb-testing
To:     weiyongjun1@huawei.com, gregkh@linuxfoundation.org,
        peter.chen@nxp.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 20 Nov 2019 20:49:00 +0100
Message-ID: <157427934022834@kroah.com>
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
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

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


