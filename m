Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4DA57496C
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 10:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389898AbfGYIy2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 04:54:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:42366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388546AbfGYIy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 04:54:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FB9522BF5;
        Thu, 25 Jul 2019 08:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564044867;
        bh=BtS5bMlfoZf54sq+wpV63u4D7gRQYNjU1VOMOEhFETI=;
        h=Subject:To:From:Date:From;
        b=OiyG6Czz74F+wmRwcFFz1wLCl2sr6ENygsN3FiTwnXkPxFeagO5fYndPanVPz0BEK
         H5Gs4dTznzN93Kwb8GoVcdY5sHpesTnRcvVhkaQ6SQEWPPrVpvwMimSvj88xy0+Hqf
         nPm5sOFTEcekkvw1qZcAsPdk/92CH6EIXC6ApxWM=
Subject: patch "usb: wusbcore: fix unbalanced get/put cluster_id" added to usb-linus
To:     tranmanphong@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 25 Jul 2019 10:54:15 +0200
Message-ID: <1564044855106209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: wusbcore: fix unbalanced get/put cluster_id

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f90bf1ece48a736097ea224430578fe586a9544c Mon Sep 17 00:00:00 2001
From: Phong Tran <tranmanphong@gmail.com>
Date: Wed, 24 Jul 2019 09:06:01 +0700
Subject: usb: wusbcore: fix unbalanced get/put cluster_id

syzboot reported that
https://syzkaller.appspot.com/bug?extid=fd2bd7df88c606eea4ef

There is not consitency parameter in cluste_id_get/put calling.
In case of getting the id with result is failure, the wusbhc->cluster_id
will not be updated and this can not be used for wusb_cluster_id_put().

Tested report
https://groups.google.com/d/msg/syzkaller-bugs/0znZopp3-9k/oxOrhLkLEgAJ

Reproduce and gdb got the details:

139		addr = wusb_cluster_id_get();
(gdb) n
140		if (addr == 0)
(gdb) print addr
$1 = 254 '\376'
(gdb) n
142		result = __hwahc_set_cluster_id(hwahc, addr);
(gdb) print result
$2 = -71
(gdb) break wusb_cluster_id_put
Breakpoint 3 at 0xffffffff836e3f20: file drivers/usb/wusbcore/wusbhc.c, line 384.
(gdb) s
Thread 2 hit Breakpoint 3, wusb_cluster_id_put (id=0 '\000') at drivers/usb/wusbcore/wusbhc.c:384
384		id = 0xff - id;
(gdb) n
385		BUG_ON(id >= CLUSTER_IDS);
(gdb) print id
$3 = 255 '\377'

Reported-by: syzbot+fd2bd7df88c606eea4ef@syzkaller.appspotmail.com
Signed-off-by: Phong Tran <tranmanphong@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20190724020601.15257-1-tranmanphong@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/hwa-hc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/hwa-hc.c b/drivers/usb/host/hwa-hc.c
index 09a8ebd95588..6968b9f2b76b 100644
--- a/drivers/usb/host/hwa-hc.c
+++ b/drivers/usb/host/hwa-hc.c
@@ -159,7 +159,7 @@ static int hwahc_op_start(struct usb_hcd *usb_hcd)
 	return result;
 
 error_set_cluster_id:
-	wusb_cluster_id_put(wusbhc->cluster_id);
+	wusb_cluster_id_put(addr);
 error_cluster_id_get:
 	goto out;
 
-- 
2.22.0


