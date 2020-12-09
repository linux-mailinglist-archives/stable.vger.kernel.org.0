Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46EEA2D3D34
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 09:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgLIIS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 03:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbgLIIS3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Dec 2020 03:18:29 -0500
Subject: patch "USB: legotower: fix logical error in recent commit" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607501868;
        bh=uhFdn2Hm2Mrvu/rdwJdNBNRCXNrjsNgWggeAAA5yj2U=;
        h=To:From:Date:From;
        b=KBx0iJ0dmXr2tqgkWname+xTVv8Eb87H/TB2FKoPPEQ4X6UyQDniiRxSQnEkM/Jt9
         033mQW7XDnOVspuAtv0TNJ+qgmWk6lyIT6ho7pBvGenzk38YPYi4sA0oAEJZMwzGaQ
         ThaiESbnlDP8Bv5okUMKRXHfzdOujVklIBPMHWBM=
To:     stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 09:18:19 +0100
Message-ID: <1607501899233173@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


