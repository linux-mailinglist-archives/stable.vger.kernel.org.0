Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3FDACBA82
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 14:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730695AbfJDMd1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 08:33:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726024AbfJDMd1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 08:33:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B31821D81;
        Fri,  4 Oct 2019 12:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570192406;
        bh=AyqByWesnvCOxyKKIdfFGVTt/0GwJsodBLb94CbC/lE=;
        h=Subject:To:From:Date:From;
        b=ury/4p668xZAvcCL/LGjeMAYZ34kCDf0Tt3nkWUfRIRhkhDAGE3HGVnzorYnvzXRc
         ukrUAhGxSh/08UUzQF+oRMbCPBGD0Ip1qPqeQpEKNyxH4PCco/FqsV2N5dWGnk6q/v
         QJXJ0HKAHVkIAkDT+Bu9XoO3B4jdpIxWG+XtjK+E=
Subject: patch "xhci: Fix NULL pointer dereference in xhci_clear_tt_buffer_complete()" added to usb-linus
To:     mathias.nyman@linux.intel.com, gregkh@linuxfoundation.org,
        johan@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 04 Oct 2019 14:33:08 +0200
Message-ID: <157019238837243@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    xhci: Fix NULL pointer dereference in xhci_clear_tt_buffer_complete()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From cfbb8a84c2d2ef49bccacb511002bca4f6053555 Mon Sep 17 00:00:00 2001
From: Mathias Nyman <mathias.nyman@linux.intel.com>
Date: Fri, 4 Oct 2019 14:59:33 +0300
Subject: xhci: Fix NULL pointer dereference in xhci_clear_tt_buffer_complete()

udev stored in ep->hcpriv might be NULL if tt buffer is cleared
due to a halted control endpoint during device enumeration

xhci_clear_tt_buffer_complete is called by hub_tt_work() once it's
scheduled,  and by then usb core might have freed and allocated a
new udev for the next enumeration attempt.

Fixes: ef513be0a905 ("usb: xhci: Add Clear_TT_Buffer")
Cc: <stable@vger.kernel.org> # v5.3
Reported-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/1570190373-30684-9-git-send-email-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 00f3804f7aa7..517ec3206f6e 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -5238,8 +5238,16 @@ static void xhci_clear_tt_buffer_complete(struct usb_hcd *hcd,
 	unsigned int ep_index;
 	unsigned long flags;
 
+	/*
+	 * udev might be NULL if tt buffer is cleared during a failed device
+	 * enumeration due to a halted control endpoint. Usb core might
+	 * have allocated a new udev for the next enumeration attempt.
+	 */
+
 	xhci = hcd_to_xhci(hcd);
 	udev = (struct usb_device *)ep->hcpriv;
+	if (!udev)
+		return;
 	slot_id = udev->slot_id;
 	ep_index = xhci_get_endpoint_index(&ep->desc);
 
-- 
2.23.0


