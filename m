Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602BB34A8FD
	for <lists+stable@lfdr.de>; Fri, 26 Mar 2021 14:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhCZNue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Mar 2021 09:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230203AbhCZNuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Mar 2021 09:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DB2961971;
        Fri, 26 Mar 2021 13:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616766622;
        bh=6XybtjrlApXQ67RWLxovaovkIU+m7doNI6S1rkPVBXo=;
        h=Subject:To:From:Date:From;
        b=W9WFK/oTY+LpzN3WMMNZO8vYjnpfHiioIrCVYeJeUSSDZ7VuMg71uBVAVjjhJ3nRT
         yYCA+8ajJxxdWuQVLxkiQZnNhuI+3+6GMEOC4OcuY43QD4kuLu9dempz7beXU+Na4d
         k4C3Uc2u1pz1xSKLkwBBB2n/+kWmrtInfIlWztAY=
Subject: patch "usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable" added to usb-linus
To:     wcheng@codeaurora.org, andy.shevchenko@gmail.com,
        gregkh@linuxfoundation.org, m.szyprowski@samsung.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 26 Mar 2021 14:50:11 +0100
Message-ID: <1616766611191239@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5aef629704ad4d983ecf5c8a25840f16e45b6d59 Mon Sep 17 00:00:00 2001
From: Wesley Cheng <wcheng@codeaurora.org>
Date: Wed, 24 Mar 2021 11:31:04 -0700
Subject: usb: dwc3: gadget: Clear DEP flags after stop transfers in ep disable

Ensure that dep->flags are cleared until after stop active transfers
is completed.  Otherwise, the ENDXFER command will not be executed
during ep disable.

Fixes: f09ddcfcb8c5 ("usb: dwc3: gadget: Prevent EP queuing while stopping transfers")
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Wesley Cheng <wcheng@codeaurora.org>
Link: https://lore.kernel.org/r/1616610664-16495-1-git-send-email-wcheng@codeaurora.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 4c15c3fce303..c7ef218e7a8c 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -791,10 +791,6 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 	reg &= ~DWC3_DALEPENA_EP(dep->number);
 	dwc3_writel(dwc->regs, DWC3_DALEPENA, reg);
 
-	dep->stream_capable = false;
-	dep->type = 0;
-	dep->flags = 0;
-
 	/* Clear out the ep descriptors for non-ep0 */
 	if (dep->number > 1) {
 		dep->endpoint.comp_desc = NULL;
@@ -803,6 +799,10 @@ static int __dwc3_gadget_ep_disable(struct dwc3_ep *dep)
 
 	dwc3_remove_requests(dwc, dep);
 
+	dep->stream_capable = false;
+	dep->type = 0;
+	dep->flags = 0;
+
 	return 0;
 }
 
-- 
2.31.0


