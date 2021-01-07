Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A602ED07D
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 14:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbhAGNSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 08:18:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbhAGNSP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 08:18:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D62022475;
        Thu,  7 Jan 2021 13:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610025455;
        bh=JZ+OaRXG+Un6oig4DRNdAgRzUYjP49BVUyO23JTKOZg=;
        h=Subject:To:From:Date:From;
        b=PjMSM2JbWkX4gHzUzoqkE+G2KhLSIFR5ND8woldhukZeNWsMD4oNYbn7E32SvqZ1e
         38uW/TeTdf/o0u+S1r0mGVGfc6EKJzCgltYl4U4Y1438WTKkRPPxy5xlIsTgvnjGH/
         aseN+HRhnv5FKb7E6R+gHNm9kbGrbtU+KmOhvJsc=
Subject: patch "usb: gadget: enable super speed plus" added to usb-linus
To:     taehyun.cho@samsung.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, lorenzo@google.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 07 Jan 2021 14:18:46 +0100
Message-ID: <161002552611875@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: gadget: enable super speed plus

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From e2459108b5a0604c4b472cae2b3cb8d3444c77fb Mon Sep 17 00:00:00 2001
From: "taehyun.cho" <taehyun.cho@samsung.com>
Date: Thu, 7 Jan 2021 00:46:25 +0900
Subject: usb: gadget: enable super speed plus

Enable Super speed plus in configfs to support USB3.1 Gen2.
This ensures that when a USB gadget is plugged in, it is
enumerated as Gen 2 and connected at 10 Gbps if the host and
cable are capable of it.

Many in-tree gadget functions (fs, midi, acm, ncm, mass_storage,
etc.) already have SuperSpeed Plus support.

Tested: plugged gadget into Linux host and saw:
[284907.385986] usb 8-2: new SuperSpeedPlus Gen 2 USB device number 3 using xhci_hcd

Tested-by: Lorenzo Colitti <lorenzo@google.com>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: taehyun.cho <taehyun.cho@samsung.com>
Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
Link: https://lore.kernel.org/r/20210106154625.2801030-1-lorenzo@google.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 408a5332a975..36ffb43f9c1a 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1543,7 +1543,7 @@ static const struct usb_gadget_driver configfs_driver_template = {
 	.suspend	= configfs_composite_suspend,
 	.resume		= configfs_composite_resume,
 
-	.max_speed	= USB_SPEED_SUPER,
+	.max_speed	= USB_SPEED_SUPER_PLUS,
 	.driver = {
 		.owner          = THIS_MODULE,
 		.name		= "configfs-gadget",
@@ -1583,7 +1583,7 @@ static struct config_group *gadgets_make(
 	gi->composite.unbind = configfs_do_nothing;
 	gi->composite.suspend = NULL;
 	gi->composite.resume = NULL;
-	gi->composite.max_speed = USB_SPEED_SUPER;
+	gi->composite.max_speed = USB_SPEED_SUPER_PLUS;
 
 	spin_lock_init(&gi->spinlock);
 	mutex_init(&gi->lock);
-- 
2.30.0


