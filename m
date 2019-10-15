Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD766D7EC4
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 20:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729937AbfJOSUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 14:20:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:42944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726358AbfJOSUC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 14:20:02 -0400
Received: from localhost (unknown [38.98.37.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E5F20663;
        Tue, 15 Oct 2019 18:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571163601;
        bh=ci/MqDA2Jj7HEkC4aExUu0OHf4jw3H5ZjZr7zUwiypA=;
        h=Subject:To:From:Date:From;
        b=vm4YbvFF0cTlcWese+VcOxQr4Hl9C2CeYYSg0sjVRC33K2pJ1J9vbDTV8gNHKACf8
         NnuTIYe2hOPe3OeLfrbEpq6xVo3x2SWRPXXS6pxZws3UIdVjD0G0TQqijz2qiSrM8d
         T7Q2d9HjI5ooz/bfH+cAP9uly8BcTaWQC0LZSkv8=
Subject: patch "USB: ldusb: fix memleak on disconnect" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 15 Oct 2019 20:14:31 +0200
Message-ID: <1571163271194135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: ldusb: fix memleak on disconnect

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From b14a39048c1156cfee76228bf449852da2f14df8 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 10 Oct 2019 14:58:34 +0200
Subject: USB: ldusb: fix memleak on disconnect

If disconnect() races with release() after a process has been
interrupted, release() could end up returning early and the driver would
fail to free its driver data.

Fixes: 2824bd250f0b ("[PATCH] USB: add ldusb driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20191010125835.27031-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/ldusb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/misc/ldusb.c b/drivers/usb/misc/ldusb.c
index f3108d85e768..147c90c2a4e5 100644
--- a/drivers/usb/misc/ldusb.c
+++ b/drivers/usb/misc/ldusb.c
@@ -380,10 +380,7 @@ static int ld_usb_release(struct inode *inode, struct file *file)
 		goto exit;
 	}
 
-	if (mutex_lock_interruptible(&dev->mutex)) {
-		retval = -ERESTARTSYS;
-		goto exit;
-	}
+	mutex_lock(&dev->mutex);
 
 	if (dev->open_count != 1) {
 		retval = -ENODEV;
-- 
2.23.0


