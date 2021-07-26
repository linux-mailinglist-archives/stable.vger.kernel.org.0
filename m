Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BD83D55D1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 10:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhGZIFL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 04:05:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231774AbhGZIFL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 04:05:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 55D8A60D07;
        Mon, 26 Jul 2021 08:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627289139;
        bh=0zYy2Zp2XTIpLKPwLNTy2/jlAxxfD5RQa+iEAXrrauw=;
        h=Subject:To:Cc:From:Date:From;
        b=EZLJG7bcSPiculhEvSSuJJchBWsiXNoullbQVM6w3lPrL1bU615Jaw1z09g0oZpJo
         NLtp9pMEJl2LaHd42OlCvKWuilr5oQ9INpspG9lZf3sOf1v6WT5MfERbj2yOmKjE1x
         DDdQ1nCcScAhvIjynowU3sKh0X/ENhTg94Zj/Qdg=
Subject: FAILED: patch "[PATCH] usb: dwc2: gadget: Fix sending zero length packet in DDMA" failed to apply to 4.9-stable tree
To:     Minas.Harutyunyan@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 26 Jul 2021 10:39:08 +0200
Message-ID: <162728874820651@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From d53dc38857f6dbefabd9eecfcbf67b6eac9a1ef4 Mon Sep 17 00:00:00 2001
From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Date: Tue, 20 Jul 2021 05:41:24 -0700
Subject: [PATCH] usb: dwc2: gadget: Fix sending zero length packet in DDMA
 mode.

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

