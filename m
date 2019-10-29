Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D46B5E83A3
	for <lists+stable@lfdr.de>; Tue, 29 Oct 2019 09:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbfJ2I5B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Oct 2019 04:57:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730260AbfJ2I5B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Oct 2019 04:57:01 -0400
Received: from localhost (unknown [91.217.168.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A5520830;
        Tue, 29 Oct 2019 08:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572339419;
        bh=3HiUJa5qwh9kHJuXh727j6pMI2kdZ0tiKbQg2dTI4r4=;
        h=Subject:To:From:Date:From;
        b=cyuTLy6grrpL5HPPHkIM/2df7NMAePftPY3jFKgvtWOQSXci9PY8+wg9tmOT8HwL2
         Rghj89tTZoHaLHHHs+tYupJG14hOVANprPiiY9F13uaUhmrJuIMpmrl50HN7o5MRJh
         lvsxi9pN7MTP+ptORsVMoqfP0BiF9OagVZ6GgB1s=
Subject: patch "USB: gadget: Reject endpoints with 0 maxpacket value" added to usb-linus
To:     stern@rowland.harvard.edu, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 29 Oct 2019 09:56:56 +0100
Message-ID: <1572339416206221@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: gadget: Reject endpoints with 0 maxpacket value

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 54f83b8c8ea9b22082a496deadf90447a326954e Mon Sep 17 00:00:00 2001
From: Alan Stern <stern@rowland.harvard.edu>
Date: Mon, 28 Oct 2019 10:54:26 -0400
Subject: USB: gadget: Reject endpoints with 0 maxpacket value

Endpoints with a maxpacket length of 0 are probably useless.  They
can't transfer any data, and it's not at all unlikely that a UDC will
crash or hang when trying to handle a non-zero-length usb_request for
such an endpoint.  Indeed, dummy-hcd gets a divide error when trying
to calculate the remainder of a transfer length by the maxpacket
value, as discovered by the syzbot fuzzer.

Currently the gadget core does not check for endpoints having a
maxpacket value of 0.  This patch adds a check to usb_ep_enable(),
preventing such endpoints from being used.

As far as I know, none of the gadget drivers in the kernel tries to
create an endpoint with maxpacket = 0, but until now there has been
nothing to prevent userspace programs under gadgetfs or configfs from
doing it.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+8ab8bf161038a8768553@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>

Link: https://lore.kernel.org/r/Pine.LNX.4.44L0.1910281052370.1485-100000@iolanthe.rowland.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 92af8dc98c3d..51fa614b4079 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -98,6 +98,17 @@ int usb_ep_enable(struct usb_ep *ep)
 	if (ep->enabled)
 		goto out;
 
+	/* UDC drivers can't handle endpoints with maxpacket size 0 */
+	if (usb_endpoint_maxp(ep->desc) == 0) {
+		/*
+		 * We should log an error message here, but we can't call
+		 * dev_err() because there's no way to find the gadget
+		 * given only ep.
+		 */
+		ret = -EINVAL;
+		goto out;
+	}
+
 	ret = ep->ops->enable(ep, ep->desc);
 	if (ret)
 		goto out;
-- 
2.23.0


