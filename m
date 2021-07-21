Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24ECE3D0A08
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 09:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhGUHKI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 03:10:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235853AbhGUHJH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 03:09:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D52B461181;
        Wed, 21 Jul 2021 07:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626853771;
        bh=yBbMWzdR+iVV4J2gXUpc87EvkRjJKUU7AVUlKJjPIek=;
        h=Subject:To:From:Date:From;
        b=FY5VCXRd/JHCSRetfT45fZkjabDQlGIKZcrhbGhRwSUndpgnNI1yT+wGk8UmUiWQA
         45BfKNPaa18+is++aMl4ICxS7BPMvyBzqc6hBNhCXyQ32O4QdMc8I1yKCE4Vz+wY8o
         AHSj1hMCWOlVEKm50eJjzwRcb0iN1lGMEcWtwCl0=
Subject: patch "usb: dwc2: gadget: Fix GOUTNAK flow for Slave mode." added to usb-linus
To:     Minas.Harutyunyan@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 21 Jul 2021 09:49:18 +0200
Message-ID: <1626853758202219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc2: gadget: Fix GOUTNAK flow for Slave mode.

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From fecb3a171db425e5068b27231f8efe154bf72637 Mon Sep 17 00:00:00 2001
From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Date: Tue, 13 Jul 2021 09:32:55 +0400
Subject: usb: dwc2: gadget: Fix GOUTNAK flow for Slave mode.

Because of dwc2_hsotg_ep_stop_xfr() function uses poll
mode, first need to mask GINTSTS_GOUTNAKEFF interrupt.
In Slave mode GINTSTS_GOUTNAKEFF interrupt will be
aserted only after pop OUT NAK status packet from RxFIFO.

In dwc2_hsotg_ep_sethalt() function before setting
DCTL_SGOUTNAK need to unmask GOUTNAKEFF interrupt.

Tested by USBCV CH9 and MSC tests set in Slave, BDMA and DDMA.
All tests are passed.

Fixes: a4f827714539a ("usb: dwc2: gadget: Disable enabled HW endpoint in dwc2_hsotg_ep_disable")
Fixes: 6070636c4918c ("usb: dwc2: Fix Stalling a Non-Isochronous OUT EP")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Link: https://lore.kernel.org/r/e17fad802bbcaf879e1ed6745030993abb93baf8.1626152924.git.Minas.Harutyunyan@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc2/gadget.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index c581ee41ac81..74d25019272f 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3900,9 +3900,27 @@ static void dwc2_hsotg_ep_stop_xfr(struct dwc2_hsotg *hsotg,
 					 __func__);
 		}
 	} else {
+		/* Mask GINTSTS_GOUTNAKEFF interrupt */
+		dwc2_hsotg_disable_gsint(hsotg, GINTSTS_GOUTNAKEFF);
+
 		if (!(dwc2_readl(hsotg, GINTSTS) & GINTSTS_GOUTNAKEFF))
 			dwc2_set_bit(hsotg, DCTL, DCTL_SGOUTNAK);
 
+		if (!using_dma(hsotg)) {
+			/* Wait for GINTSTS_RXFLVL interrupt */
+			if (dwc2_hsotg_wait_bit_set(hsotg, GINTSTS,
+						    GINTSTS_RXFLVL, 100)) {
+				dev_warn(hsotg->dev, "%s: timeout GINTSTS.RXFLVL\n",
+					 __func__);
+			} else {
+				/*
+				 * Pop GLOBAL OUT NAK status packet from RxFIFO
+				 * to assert GOUTNAKEFF interrupt
+				 */
+				dwc2_readl(hsotg, GRXSTSP);
+			}
+		}
+
 		/* Wait for global nak to take effect */
 		if (dwc2_hsotg_wait_bit_set(hsotg, GINTSTS,
 					    GINTSTS_GOUTNAKEFF, 100))
@@ -4348,6 +4366,9 @@ static int dwc2_hsotg_ep_sethalt(struct usb_ep *ep, int value, bool now)
 		epctl = dwc2_readl(hs, epreg);
 
 		if (value) {
+			/* Unmask GOUTNAKEFF interrupt */
+			dwc2_hsotg_en_gsint(hs, GINTSTS_GOUTNAKEFF);
+
 			if (!(dwc2_readl(hs, GINTSTS) & GINTSTS_GOUTNAKEFF))
 				dwc2_set_bit(hs, DCTL, DCTL_SGOUTNAK);
 			// STALL bit will be set in GOUTNAKEFF interrupt handler
-- 
2.32.0


