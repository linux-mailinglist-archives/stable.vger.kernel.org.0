Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F2D454818
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236978AbhKQOGY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:06:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237037AbhKQOGX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:06:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D5DF6139F;
        Wed, 17 Nov 2021 14:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157804;
        bh=1UdgZ7NcHJlERj5KdGwNujaSKdliU73ToHYQgy7P8Gk=;
        h=Subject:To:From:Date:From;
        b=rJmXc0fMqGzArofdRHWMaYwHYmNLJlvCX8Wfs6kUb0ViNPhJd+5gjUrnGgFe06E9E
         GVuKnsr3cQS5oW9WV3Hs5C1EuJvQ1NEcObGGuWJFt8MF/r/zxd7P5SVIVz/aj4D1Pj
         7SU0vN26wgTWntDfO2AeLQh2QKx0Pmm9sjnJ7E84=
Subject: patch "usb: dwc3: gadget: Fix null pointer exception" added to usb-linus
To:     albertccwang@google.com, gregkh@linuxfoundation.org,
        quic_jackp@quicinc.com, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:03:09 +0100
Message-ID: <16371577895199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Fix null pointer exception

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 26288448120b28af1dfd85a6fa6b6d55a16c7f2f Mon Sep 17 00:00:00 2001
From: Albert Wang <albertccwang@google.com>
Date: Tue, 9 Nov 2021 17:26:42 +0800
Subject: usb: dwc3: gadget: Fix null pointer exception

In the endpoint interrupt functions
dwc3_gadget_endpoint_transfer_in_progress() and
dwc3_gadget_endpoint_trbs_complete() will dereference the endpoint
descriptor. But it could be cleared in __dwc3_gadget_ep_disable()
when accessory disconnected. So we need to check whether it is null
or not before dereferencing it.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Jack Pham <quic_jackp@quicinc.com>
Signed-off-by: Albert Wang <albertccwang@google.com>
Link: https://lore.kernel.org/r/20211109092642.3507692-1-albertccwang@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index daa8f8548a2e..7e3db00e9759 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -3263,6 +3263,9 @@ static bool dwc3_gadget_endpoint_trbs_complete(struct dwc3_ep *dep,
 	struct dwc3		*dwc = dep->dwc;
 	bool			no_started_trb = true;
 
+	if (!dep->endpoint.desc)
+		return no_started_trb;
+
 	dwc3_gadget_ep_cleanup_completed_requests(dep, event, status);
 
 	if (dep->flags & DWC3_EP_END_TRANSFER_PENDING)
@@ -3310,6 +3313,9 @@ static void dwc3_gadget_endpoint_transfer_in_progress(struct dwc3_ep *dep,
 {
 	int status = 0;
 
+	if (!dep->endpoint.desc)
+		return;
+
 	if (usb_endpoint_xfer_isoc(dep->endpoint.desc))
 		dwc3_gadget_endpoint_frame_from_event(dep, event);
 
-- 
2.34.0


