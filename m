Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D45B2D2677
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 09:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgLHImA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 03:42:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbgLHImA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 03:42:00 -0500
Subject: patch "USB: dummy-hcd: Fix uninitialized array use in init()" added to usb-next
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1607416879;
        bh=H5iabnmrDVVq4vUMrr/b0Mbz+FiMDbES1J3XcnUoyOE=;
        h=To:From:Date:From;
        b=kOWf+AzbbX5mKZWFixeNVy+bT6e04VHInyInbUjpIDc4bNAB1v1yDX/FjrW9sbL4N
         LEFwB8flsl1rli3UYyal05fiF5g1O1hsoyxKEmCie4R6sdhwOJkiEVl1Cnzg4b00vr
         RT1HMOHJ62078VxfDrqe0mm2lN6IvpljVlJ/f7FY=
To:     minhquangbui99@gmail.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Dec 2020 09:42:14 +0100
Message-ID: <1607416934116126@kroah.com>
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
in the usb-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

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


