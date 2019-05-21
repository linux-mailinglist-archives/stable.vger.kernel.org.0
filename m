Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 006E8249CE
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 10:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfEUIJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 04:09:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:33796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbfEUIJQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 21 May 2019 04:09:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F5C2173E;
        Tue, 21 May 2019 08:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558426155;
        bh=w4f7ru5ftlSuwrOUYG1XkV6VDhHkonFdzkYtQgBRtqg=;
        h=Subject:To:From:Date:From;
        b=JsI/JkfQIimTuQ6f4e865dZ1hMQ0IBKOlBIkhdbX1oywII9WnZ0EuGfLXp41bP/fp
         C+lxFCtpfiIDZ3csy25yVbt4fEDP9b+RxFcD7W+PWPDkg8QFRnMXcXcZaGwMsxiSw0
         oGK0grc4qFYE2jRMNBSSYdlU4nQwaCODjYqA3JwA=
Subject: patch "USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor" added to usb-linus
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 May 2019 10:09:13 +0200
Message-ID: <1558426153192227@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a03ff54460817c76105f81f3aa8ef655759ccc9a Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 13 May 2019 13:14:29 -0400
Subject: USB: Fix slab-out-of-bounds write in usb_get_bos_descriptor

The syzkaller USB fuzzer found a slab-out-of-bounds write bug in the
USB core, caused by a failure to check the actual size of a BOS
descriptor.  This patch adds a check to make sure the descriptor is at
least as large as it is supposed to be, so that the code doesn't
inadvertently access memory beyond the end of the allocated region
when assigning to dev->bos->desc->bNumDeviceCaps later on.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+71f1e64501a309fcc012@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 20ff036b4c22..9d6cb709ca7b 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -932,8 +932,8 @@ int usb_get_bos_descriptor(struct usb_device *dev)
 
 	/* Get BOS descriptor */
 	ret = usb_get_descriptor(dev, USB_DT_BOS, 0, bos, USB_DT_BOS_SIZE);
-	if (ret < USB_DT_BOS_SIZE) {
-		dev_err(ddev, "unable to get BOS descriptor\n");
+	if (ret < USB_DT_BOS_SIZE || bos->bLength < USB_DT_BOS_SIZE) {
+		dev_err(ddev, "unable to get BOS descriptor or descriptor too short\n");
 		if (ret >= 0)
 			ret = -ENOMSG;
 		kfree(bos);
-- 
2.21.0


