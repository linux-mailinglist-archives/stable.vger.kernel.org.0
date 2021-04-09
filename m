Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7884A359FAA
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 15:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhDINRe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 09:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDINRd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 09:17:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75D43610FB;
        Fri,  9 Apr 2021 13:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617974240;
        bh=mj9ng5mnlUJ2y/Nx/U3q6xwvJCeCc+8BQWG7PVb6iMs=;
        h=Subject:To:From:Date:From;
        b=1DjxatlGdCNb9UuJCFjf+Bya5Xz8YOF2nUpto19DN2veo/MNxsG0k1rnzYVsqe3n0
         bJ+ztNz1mZqYI9dKb3QgB9BaCryoz3SZn7An5pW8IKIemGeOOWOqNyERqvTy8zOHIt
         2R68BmflEAEvo34EuPpmXRWarkF5pHHCQP+D6zAU=
Subject: patch "usb: dwc2: Fix session request interrupt handler" added to usb-testing
To:     Arthur.Petrosyan@synopsys.com, Minas.Harutyunyan@synopsys.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 09 Apr 2021 15:17:00 +0200
Message-ID: <161797422020658@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: Fix session request interrupt handler

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 42b32b164acecd850edef010915a02418345a033 Mon Sep 17 00:00:00 2001
From: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Date: Thu, 8 Apr 2021 13:45:49 +0400
Subject: usb: dwc2: Fix session request interrupt handler

According to programming guide in host mode, port
power must be turned on in session request
interrupt handlers.

Fixes: 21795c826a45 ("usb: dwc2: exit hibernation on session request")
Cc: <stable@vger.kernel.org>
Acked-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Signed-off-by: Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
Link: https://lore.kernel.org/r/20210408094550.75484A0094@mailhost.synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/core_intr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/usb/dwc2/core_intr.c b/drivers/usb/dwc2/core_intr.c
index 0a7f9330907f..8c0152b514be 100644
--- a/drivers/usb/dwc2/core_intr.c
+++ b/drivers/usb/dwc2/core_intr.c
@@ -307,6 +307,7 @@ static void dwc2_handle_conn_id_status_change_intr(struct dwc2_hsotg *hsotg)
 static void dwc2_handle_session_req_intr(struct dwc2_hsotg *hsotg)
 {
 	int ret;
+	u32 hprt0;
 
 	/* Clear interrupt */
 	dwc2_writel(hsotg, GINTSTS_SESSREQINT, GINTSTS);
@@ -328,6 +329,13 @@ static void dwc2_handle_session_req_intr(struct dwc2_hsotg *hsotg)
 		 * established
 		 */
 		dwc2_hsotg_disconnect(hsotg);
+	} else {
+		/* Turn on the port power bit. */
+		hprt0 = dwc2_read_hprt0(hsotg);
+		hprt0 |= HPRT0_PWR;
+		dwc2_writel(hsotg, hprt0, HPRT0);
+		/* Connect hcd after port power is set. */
+		dwc2_hcd_connect(hsotg);
 	}
 }
 
-- 
2.31.1


