Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4127E3D0A12
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbhGUHMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 03:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235853AbhGUHKr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 03:10:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9A8C600D1;
        Wed, 21 Jul 2021 07:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626853881;
        bh=SUPuerpeQ6ra7zkWsgJOsNChyYcE8CLJkaefuyRublw=;
        h=Subject:To:From:Date:From;
        b=zDWoc3L/2IeYuEEsNeqLERdhwliv5rCk+kUJ/zL1KabvR/i6tb1kFmPW1fH3YwHXK
         Bv8d93vuHjypNSx3wXew27lZTNeZxa0HIKmwhLMwi+zbIiunqH5Qdg0Dk989NKV/gm
         WHRLohCMiw8Oo+hB9wJzegkEFbi4A4WToMDhcriY=
Subject: patch "usb: dwc2: gadget: Fix sending zero length packet in DDMA mode." added to usb-linus
To:     Minas.Harutyunyan@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:51:09 +0200
Message-ID: <1626853869235198@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From d53dc38857f6dbefabd9eecfcbf67b6eac9a1ef4 Mon Sep 17 00:00:00 2001
From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Date: Tue, 20 Jul 2021 05:41:24 -0700
Subject: usb: dwc2: gadget: Fix sending zero length packet in DDMA mode.

Sending zero length packet in DDMA mode perform by DMA descriptor
by setting SP (short packet) flag.

For DDMA in function dwc2_hsotg_complete_in() does not need to send
zlp.

Tested by USBCV MSC tests.

Fixes: f71b5e2533de ("usb: dwc2: gadget: fix zero length packet transfers")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/967bad78c55dd2db1c19714eee3d0a17cf99d74a.1626777738.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 74d25019272f..3146df6e6510 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -2749,12 +2749,14 @@ static void dwc2_hsotg_complete_in(struct dwc2_hsotg *hsotg,
 		return;
 	}
 
-	/* Zlp for all endpoints, for ep0 only in DATA IN stage */
+	/* Zlp for all endpoints in non DDMA, for ep0 only in DATA IN stage */
 	if (hs_ep->send_zlp) {
-		dwc2_hsotg_program_zlp(hsotg, hs_ep);
 		hs_ep->send_zlp = 0;
-		/* transfer will be completed on next complete interrupt */
-		return;
+		if (!using_desc_dma(hsotg)) {
+			dwc2_hsotg_program_zlp(hsotg, hs_ep);
+			/* transfer will be completed on next complete interrupt */
+			return;
+		}
 	}
 
 	if (hs_ep->index == 0 && hsotg->ep0_state == DWC2_EP0_DATA_IN) {
-- 
2.32.0


