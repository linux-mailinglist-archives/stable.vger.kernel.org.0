Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAEA2D34A8
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 22:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729348AbgLHUyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 15:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728419AbgLHUy0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 15:54:26 -0500
Subject: patch "USB: legotower: fix logical error in recent commit" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607453651;
        bh=PRPWrJc0O/XyIzFK/lhvocSpHdsyMqzB8T5I3OJ+4Uc=;
        h=To:From:Date:From;
        b=hnWDWlH1YB//BEJHSTSQzLNIrjyL5iPN+p1vm2Jq48TeuyDgO3uK1umQGSH2ABv6d
         6Wkrl0SG49wemSis9GXtWKlCXK7LN8tVqi4Zm4FXViqGvdv+24o0meHVn3rkwMXbM2
         0RT3LhYUg0ppA9ItHn1x3fB32b516e6DdGYIJQfI=
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Dec 2020 19:55:29 +0100
Message-ID: <1607453729134107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: legotower: fix logical error in recent commit

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From b175d273d4e4100b66e68f0675fef7a3c07a7957 Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 8 Dec 2020 11:30:42 -0500
Subject: USB: legotower: fix logical error in recent commit

Commit d9f0d82f06c6 ("USB: legousbtower: use usb_control_msg_recv()")
contained an elementary logical error.  The check of the return code
from the new usb_control_msg_recv() function was inverted.

Reported-and-tested-by: syzbot+9be25235b7a69b24d117@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20201208163042.GD1298255@rowland.harvard.edu
Fixes: d9f0d82f06c6 ("USB: legousbtower: use usb_control_msg_recv()")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/legousbtower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/misc/legousbtower.c b/drivers/usb/misc/legousbtower.c
index ba655b4af4fc..1c9e09138c10 100644
--- a/drivers/usb/misc/legousbtower.c
+++ b/drivers/usb/misc/legousbtower.c
@@ -797,7 +797,7 @@ static int tower_probe(struct usb_interface *interface, const struct usb_device_
 				      &get_version_reply,
 				      sizeof(get_version_reply),
 				      1000, GFP_KERNEL);
-	if (!result) {
+	if (result) {
 		dev_err(idev, "get version request failed: %d\n", result);
 		retval = result;
 		goto error;
-- 
2.29.2


