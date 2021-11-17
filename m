Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508D8454815
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbhKQOGO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:06:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:60452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238015AbhKQOGM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:06:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E6C46139F;
        Wed, 17 Nov 2021 14:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157793;
        bh=Pa0o9Pv9e04ki5KNrwgf0GTjXkEgWo+VF4OmzRhbAac=;
        h=Subject:To:From:Date:From;
        b=aw0jQnlO4Yy97nqGoyk50mEg9lKc5O/Itat9b4rDC1kl0nRMlDCAi7A1N2im8Nj2l
         tfaxmjNlClTslYrT8rbSXUeqEOOCpnIH78AyRg30jRllLcnqGdunCNK2SO7z8WhiOH
         FdD6AclcW+u8MD4wpyqcvdCcOcymkJjcf9dc4b9M=
Subject: patch "usb: dwc3: gadget: Ignore NoStream after End Transfer" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:03:06 +0100
Message-ID: <163715778662178@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Ignore NoStream after End Transfer

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d74dc3e9f58c28689cef1faccf918e06587367d3 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Mon, 25 Oct 2021 16:21:10 -0700
Subject: usb: dwc3: gadget: Ignore NoStream after End Transfer

The End Transfer command from a stream endpoint will generate a NoStream
event, and we should ignore it. Currently we set the flag
DWC3_EP_IGNORE_NEXT_NOSTREAM to track this prior to sending the command,
and it will be cleared on the next stream event. However, a stream event
may be generated before the End Transfer command completion and
prematurely clear the flag. Fix this by setting the flag on End Transfer
completion instead.

Fixes: 140ca4cfea8a ("usb: dwc3: gadget: Handle stream transfers")
Cc: <stable@vger.kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/cee1253af4c3600edb878d11c9c08b040817ae23.1635203975.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 23de2a5a40d6..3d6f4adaa15a 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3352,6 +3352,14 @@ static void dwc3_gadget_endpoint_command_complete(struct dwc3_ep *dep,
 	if (cmd != DWC3_DEPCMD_ENDTRANSFER)
 		return;
 
+	/*
+	 * The END_TRANSFER command will cause the controller to generate a
+	 * NoStream Event, and it's not due to the host DP NoStream rejection.
+	 * Ignore the next NoStream event.
+	 */
+	if (dep->stream_capable)
+		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
+
 	dep->flags &= ~DWC3_EP_END_TRANSFER_PENDING;
 	dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	dwc3_gadget_ep_cleanup_cancelled_requests(dep);
@@ -3574,14 +3582,6 @@ static void dwc3_stop_active_transfer(struct dwc3_ep *dep, bool force,
 	WARN_ON_ONCE(ret);
 	dep->resource_index = 0;
 
-	/*
-	 * The END_TRANSFER command will cause the controller to generate a
-	 * NoStream Event, and it's not due to the host DP NoStream rejection.
-	 * Ignore the next NoStream event.
-	 */
-	if (dep->stream_capable)
-		dep->flags |= DWC3_EP_IGNORE_NEXT_NOSTREAM;
-
 	if (!interrupt)
 		dep->flags &= ~DWC3_EP_TRANSFER_STARTED;
 	else
-- 
2.34.0


