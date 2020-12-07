Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C59922D13A7
	for <lists+stable@lfdr.de>; Mon,  7 Dec 2020 15:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgLGO15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 09:27:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgLGO15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 09:27:57 -0500
Subject: patch "USB: dummy-hcd: Fix uninitialized array use in init()" added to usb-testing
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607351231;
        bh=S7d/obdW9zHWzInHftoUKcVT5D3ixt0IwKGxd1Oib1o=;
        h=To:From:Date:From;
        b=irjSHWyBD44Ou1bp/QEvXYNbLikPOJ0RoKlxRuVKWXDuDA4FTqbmSe2ya8S4LYkmG
         sWITC4Z3DtgFTlBuYCqeCcL+Fzb0Y/6pONUrbz2yRcVzNKxL1vkpP1IxvlfU0ChTpU
         1bYPQBLWRByaqPaDx57brRtk+59s4wU9esoluLKs=
To:     minhquangbui99@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 07 Dec 2020 15:28:21 +0100
Message-ID: <160735130119229@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: dummy-hcd: Fix uninitialized array use in init()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From e90cfa813da7a527785033a0b247594c2de93dd8 Mon Sep 17 00:00:00 2001
From: Bui Quang Minh <minhquangbui99@gmail.com>
Date: Fri, 4 Dec 2020 06:24:49 +0000
Subject: USB: dummy-hcd: Fix uninitialized array use in init()

This error path

	err_add_pdata:
		for (i = 0; i < mod_data.num; i++)
			kfree(dum[i]);

can be triggered when not all dum's elements are initialized.

Fix this by initializing all dum's elements to NULL.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Link: https://lore.kernel.org/r/1607063090-3426-1-git-send-email-minhquangbui99@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/dummy_hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
index f6b407778179..ab5e978b5052 100644
--- a/drivers/usb/gadget/udc/dummy_hcd.c
+++ b/drivers/usb/gadget/udc/dummy_hcd.c
@@ -2738,7 +2738,7 @@ static int __init init(void)
 {
 	int	retval = -ENOMEM;
 	int	i;
-	struct	dummy *dum[MAX_NUM_UDC];
+	struct	dummy *dum[MAX_NUM_UDC] = {};
 
 	if (usb_disabled())
 		return -ENODEV;
-- 
2.29.2


