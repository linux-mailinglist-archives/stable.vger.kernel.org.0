Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2718DA48
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730153AbfHNROG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:14:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:38470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731003AbfHNROE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:14:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA3982063F;
        Wed, 14 Aug 2019 17:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802843;
        bh=/+s4HMn3sa4TeIGmpwGhMZ5kCW8zQtP0FeVr6XKuY+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAkyJNAoKQzL9vcPSXDoaRe2HYefS6/Ykq4VNWsAcH7XWSdTzi4YNoQb3nZFEnNE7
         cjQcR2tJXkXFsNrn+ixektzjsOqaSPTHp3OGfsHU3igPp5ppOwTJBESSKWBA/PZD6Q
         FSandpupP8RXlIQTXjNZN1mmku9mHZYq0PM7wFWQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Subject: [PATCH 4.14 21/69] usb: host: xhci-rcar: Fix timeout in xhci_suspend()
Date:   Wed, 14 Aug 2019 19:01:19 +0200
Message-Id: <20190814165746.965617011@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165744.822314328@linuxfoundation.org>
References: <20190814165744.822314328@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit 783bda5e41acc71f98336e1a402c180f9748e5dc upstream.

When a USB device is connected to the host controller and
the system enters suspend, the following error happens
in xhci_suspend():

	xhci-hcd ee000000.usb: WARN: xHC CMD_RUN timeout

Since the firmware/internal CPU control the USBSTS.STS_HALT
and the process speed is down when the roothub port enters U3,
long delay for the handshake of STS_HALT is neeed in xhci_suspend().
So, this patch adds to set the XHCI_SLOW_SUSPEND.

Fixes: 435cc1138ec9 ("usb: host: xhci-plat: set resume_quirk() for R-Car controllers")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/1564734815-17964-1-git-send-email-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-rcar.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/xhci-rcar.c
+++ b/drivers/usb/host/xhci-rcar.c
@@ -231,10 +231,15 @@ int xhci_rcar_init_quirk(struct usb_hcd
 	 * pointers. So, this driver clears the AC64 bit of xhci->hcc_params
 	 * to call dma_set_coherent_mask(dev, DMA_BIT_MASK(32)) in
 	 * xhci_gen_setup().
+	 *
+	 * And, since the firmware/internal CPU control the USBSTS.STS_HALT
+	 * and the process speed is down when the roothub port enters U3,
+	 * long delay for the handshake of STS_HALT is neeed in xhci_suspend().
 	 */
 	if (xhci_rcar_is_gen2(hcd->self.controller) ||
-			xhci_rcar_is_gen3(hcd->self.controller))
-		xhci->quirks |= XHCI_NO_64BIT_SUPPORT;
+			xhci_rcar_is_gen3(hcd->self.controller)) {
+		xhci->quirks |= XHCI_NO_64BIT_SUPPORT | XHCI_SLOW_SUSPEND;
+	}
 
 	xhci->quirks |= XHCI_TRUST_TX_LENGTH;
 	return xhci_rcar_download_firmware(hcd);


