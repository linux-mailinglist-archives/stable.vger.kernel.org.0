Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AAE25DC2E
	for <lists+stable@lfdr.de>; Fri,  4 Sep 2020 16:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730237AbgIDOph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Sep 2020 10:45:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730021AbgIDOpg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Sep 2020 10:45:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10A3E2074D;
        Fri,  4 Sep 2020 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599230735;
        bh=gaa9CHW11kysdCKNOpgna0PkjGDNsYs0oj0FOs/JlZg=;
        h=Subject:To:From:Date:From;
        b=ehm6Fo3eIOEHVh33ib4tUSC40xMOTa2w/61pyy+jqKNSQdyI7THseekRi/gFzxafS
         r+xR/Fx4ezXJ894HytJaMN+KlG+XAcDLcVqqHKR2v3el+f7MJvtd4XOrGFS1kYSwYo
         gl3YcEPjEYiPdI7BzWeoQlMTGixA6oyYm5qNhrkI=
Subject: patch "usb: core: fix slab-out-of-bounds Read in read_descriptors" added to usb-linus
To:     prime.zeng@hisilicon.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Sep 2020 16:45:49 +0200
Message-ID: <1599230749186137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: core: fix slab-out-of-bounds Read in read_descriptors

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From a18cd6c9b6bc73dc17e8b7e9bd07decaa8833c97 Mon Sep 17 00:00:00 2001
From: Zeng Tao <prime.zeng@hisilicon.com>
Date: Fri, 4 Sep 2020 14:37:44 +0800
Subject: usb: core: fix slab-out-of-bounds Read in read_descriptors

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
Link: https://lore.kernel.org/r/1599201467-11000-1-git-send-email-prime.zeng@hisilicon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/sysfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index a2ca38e25e0c..8d134193fa0c 100644
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
2.28.0


