Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56C193D60F2
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237789AbhGZPZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238135AbhGZPYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:24:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C87B560F5B;
        Mon, 26 Jul 2021 16:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315523;
        bh=tEuF0ItmfD17ajwzoBUXjU/UjgdHv2A7qWLQfgQM3x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfYx7r9Kv12faQRF9pZhLF/rSBZRF94ifNK0eJVZe8jSgZ89Mik1CZgpWmqlNH41I
         PGlpn0/zYruXR2hLlbT3iziHQv0o3OEZ1Sf2UHLqmseE2ouxzTidyr6DBLMWe0zEAE
         LesS2orSDd6qS5Wp0APnhIgtLOl9/AmIM3d+Veq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
Subject: [PATCH 5.10 130/167] usb: dwc2: gadget: Fix GOUTNAK flow for Slave mode.
Date:   Mon, 26 Jul 2021 17:39:23 +0200
Message-Id: <20210726153843.760467546@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>

commit fecb3a171db425e5068b27231f8efe154bf72637 upstream.

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
 drivers/usb/dwc2/gadget.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -3900,9 +3900,27 @@ static void dwc2_hsotg_ep_stop_xfr(struc
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
@@ -4348,6 +4366,9 @@ static int dwc2_hsotg_ep_sethalt(struct
 		epctl = dwc2_readl(hs, epreg);
 
 		if (value) {
+			/* Unmask GOUTNAKEFF interrupt */
+			dwc2_hsotg_en_gsint(hs, GINTSTS_GOUTNAKEFF);
+
 			if (!(dwc2_readl(hs, GINTSTS) & GINTSTS_GOUTNAKEFF))
 				dwc2_set_bit(hs, DCTL, DCTL_SGOUTNAK);
 			// STALL bit will be set in GOUTNAKEFF interrupt handler


