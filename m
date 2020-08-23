Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0132324EDDF
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 17:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgHWPNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 11:13:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726935AbgHWPM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Aug 2020 11:12:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFEB52067C;
        Sun, 23 Aug 2020 15:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598195577;
        bh=LZ4npTv38NibDneLqmRxgfJajd+U5Vxp3jhJEPHlvFs=;
        h=Subject:To:From:Date:From;
        b=iS3AHlEq/iOmyX6v6tLfzAUvT+SgA803gZlfuYI6xr4E1OEpvuVX29HL4i/eqz3X9
         hXqbKGABOS2QX9ibvroYt2Tu+dxyu/9Ofm2oY5deF9DsKrk9GZ0Nb3Aut+EvZjYuDL
         H4ynhj/pEX6+G/vzLT67nJ53xbTZK/KLhLusGAnk=
Subject: patch "xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed" added to usb-linus
To:     dinghui@sangfor.com.cn, gregkh@linuxfoundation.org,
        mathias.nyman@linux.intel.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 17:13:07 +0200
Message-ID: <159819558791254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f1ec7ae6c9f8c016db320e204cb519a1da1581b8 Mon Sep 17 00:00:00 2001
From: Ding Hui <dinghui@sangfor.com.cn>
Date: Fri, 21 Aug 2020 12:15:49 +0300
Subject: xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep reset failed

Some device drivers call libusb_clear_halt when target ep queue
is not empty. (eg. spice client connected to qemu for usb redir)

Before commit f5249461b504 ("xhci: Clear the host side toggle
manually when endpoint is soft reset"), that works well.
But now, we got the error log:

    EP not empty, refuse reset

xhci_endpoint_reset failed and left ep_state's EP_SOFT_CLEAR_TOGGLE
bit still set

So all the subsequent urb sumbits to the ep will fail with the
warn log:

    Can't enqueue URB while manually clearing toggle

We need to clear ep_state EP_SOFT_CLEAR_TOGGLE bit after
xhci_endpoint_reset, even if it failed.

Fixes: f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset")
Cc: stable <stable@vger.kernel.org> # v4.17+
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20200821091549.20556-4-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 3c41b14ecce7..e9884ae9c77d 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3236,10 +3236,11 @@ static void xhci_endpoint_reset(struct usb_hcd *hcd,
 
 	wait_for_completion(cfg_cmd->completion);
 
-	ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
 	xhci_free_command(xhci, cfg_cmd);
 cleanup:
 	xhci_free_command(xhci, stop_cmd);
+	if (ep->ep_state & EP_SOFT_CLEAR_TOGGLE)
+		ep->ep_state &= ~EP_SOFT_CLEAR_TOGGLE;
 }
 
 static int xhci_check_streams_endpoint(struct xhci_hcd *xhci,
-- 
2.28.0


