Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5A283F86B8
	for <lists+stable@lfdr.de>; Thu, 26 Aug 2021 13:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242367AbhHZLvS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Aug 2021 07:51:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:42864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242372AbhHZLvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Aug 2021 07:51:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D94D861002;
        Thu, 26 Aug 2021 11:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629978628;
        bh=mu7YjhmTbkiSMkcfCToBX8ZoEp3/C3dYSaWO8pT4yi8=;
        h=Subject:To:From:Date:From;
        b=V3TxGSy7PJuYbEqYc+oG5j1dJ+ixaHfSUnocyzBVYl6stBZhhc8MYlWatHaU4bA9C
         ssoSiRTC05D7bCY2mrffQ2PZMQka4GYApTeHrjYVqEv69qpKayAda7oDvc+a0ufGNv
         I9klar8NSileVg9v93wk4BXyYP25obioTxTSq5Jc=
Subject: patch "usb: dwc3: gadget: Fix dwc3_calc_trbs_left()" added to usb-linus
To:     Thinh.Nguyen@synopsys.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 26 Aug 2021 13:50:25 +0200
Message-ID: <162997862517164@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 51f1954ad853d01ba4dc2b35dee14d8490ee05a1 Mon Sep 17 00:00:00 2001
From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Date: Thu, 19 Aug 2021 03:17:03 +0200
Subject: usb: dwc3: gadget: Fix dwc3_calc_trbs_left()

We can't depend on the TRB's HWO bit to determine if the TRB ring is
"full". A TRB is only available when the driver had processed it, not
when the controller consumed and relinquished the TRB's ownership to the
driver. Otherwise, the driver may overwrite unprocessed TRBs. This can
happen when many transfer events accumulate and the system is slow to
process them and/or when there are too many small requests.

If a request is in the started_list, that means there is one or more
unprocessed TRBs remained. Check this instead of the TRB's HWO bit
whether the TRB ring is full.

Fixes: c4233573f6ee ("usb: dwc3: gadget: prepare TRBs on update transfers too")
Cc: <stable@vger.kernel.org>
Acked-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/e91e975affb0d0d02770686afc3a5b9eb84409f6.1629335416.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 84fe57ef5a49..1e6ddbc986ba 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -940,19 +940,19 @@ static struct dwc3_trb *dwc3_ep_prev_trb(struct dwc3_ep *dep, u8 index)
 
 static u32 dwc3_calc_trbs_left(struct dwc3_ep *dep)
 {
-	struct dwc3_trb		*tmp;
 	u8			trbs_left;
 
 	/*
-	 * If enqueue & dequeue are equal than it is either full or empty.
-	 *
-	 * One way to know for sure is if the TRB right before us has HWO bit
-	 * set or not. If it has, then we're definitely full and can't fit any
-	 * more transfers in our ring.
+	 * If the enqueue & dequeue are equal then the TRB ring is either full
+	 * or empty. It's considered full when there are DWC3_TRB_NUM-1 of TRBs
+	 * pending to be processed by the driver.
 	 */
 	if (dep->trb_enqueue == dep->trb_dequeue) {
-		tmp = dwc3_ep_prev_trb(dep, dep->trb_enqueue);
-		if (tmp->ctrl & DWC3_TRB_CTRL_HWO)
+		/*
+		 * If there is any request remained in the started_list at
+		 * this point, that means there is no TRB available.
+		 */
+		if (!list_empty(&dep->started_list))
 			return 0;
 
 		return DWC3_TRB_NUM - 1;
-- 
2.32.0


