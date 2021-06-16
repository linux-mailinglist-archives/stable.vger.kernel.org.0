Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD68C3A9415
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 09:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhFPHgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 03:36:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231132AbhFPHgC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Jun 2021 03:36:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C4B2D60FEA;
        Wed, 16 Jun 2021 07:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623828837;
        bh=f4THeaROB/EUb5al3ZHzm5/vIw6aUtEe7e7IjwIYo/U=;
        h=Subject:To:From:Date:From;
        b=o9q8svVn9ZmI1SXZQz/F3y1PlUoRiCmizlq5nWQ8xiYI9z4iFDK2vAP6GSLYxNRTk
         GlQJG2EHkiuA9WVsaZ9L0AGormwF96Eoa5jqTB4UvCzLlJoRtEGpL+Tsu/pV6dXf6Z
         EZsjSQLkSXNC+fRrwJIY27jlBsjPILST+wQb5/K0=
Subject: patch "usb: chipidea: imx: Fix Battery Charger 1.2 CDP detection" added to usb-linus
To:     breno.lima@nxp.com, jun.li@nxp.com, peter.chen@kernel.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 16 Jun 2021 09:33:54 +0200
Message-ID: <162382883454105@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: chipidea: imx: Fix Battery Charger 1.2 CDP detection

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From c6d580d96f140596d69220f60ce0cfbea4ee5c0f Mon Sep 17 00:00:00 2001
From: Breno Lima <breno.lima@nxp.com>
Date: Mon, 14 Jun 2021 13:50:13 -0400
Subject: usb: chipidea: imx: Fix Battery Charger 1.2 CDP detection

i.MX8MM cannot detect certain CDP USB HUBs. usbmisc_imx.c driver is not
following CDP timing requirements defined by USB BC 1.2 specification
and section 3.2.4 Detection Timing CDP.

During Primary Detection the i.MX device should turn on VDP_SRC and
IDM_SINK for a minimum of 40ms (TVDPSRC_ON). After a time of TVDPSRC_ON,
the i.MX is allowed to check the status of the D- line. Current
implementation is waiting between 1ms and 2ms, and certain BC 1.2
complaint USB HUBs cannot be detected. Increase delay to 40ms allowing
enough time for primary detection.

During secondary detection the i.MX is required to disable VDP_SRC and
IDM_SNK, and enable VDM_SRC and IDP_SINK for at least 40ms (TVDMSRC_ON).

Current implementation is not disabling VDP_SRC and IDM_SNK, introduce
disable sequence in imx7d_charger_secondary_detection() function.

VDM_SRC and IDP_SINK should be enabled for at least 40ms (TVDMSRC_ON).
Increase delay allowing enough time for detection.

Cc: <stable@vger.kernel.org>
Fixes: 746f316b753a ("usb: chipidea: introduce imx7d USB charger detection")
Signed-off-by: Breno Lima <breno.lima@nxp.com>
Signed-off-by: Jun Li <jun.li@nxp.com>
Link: https://lore.kernel.org/r/20210614175013.495808-1-breno.lima@nxp.com
Signed-off-by: Peter Chen <peter.chen@kernel.org>
---
 drivers/usb/chipidea/usbmisc_imx.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/usbmisc_imx.c b/drivers/usb/chipidea/usbmisc_imx.c
index 4545b23bda3f..bac0f5458cab 100644
--- a/drivers/usb/chipidea/usbmisc_imx.c
+++ b/drivers/usb/chipidea/usbmisc_imx.c
@@ -686,6 +686,16 @@ static int imx7d_charger_secondary_detection(struct imx_usbmisc_data *data)
 	int val;
 	unsigned long flags;
 
+	/* Clear VDATSRCENB0 to disable VDP_SRC and IDM_SNK required by BC 1.2 spec */
+	spin_lock_irqsave(&usbmisc->lock, flags);
+	val = readl(usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
+	val &= ~MX7D_USB_OTG_PHY_CFG2_CHRG_VDATSRCENB0;
+	writel(val, usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
+	spin_unlock_irqrestore(&usbmisc->lock, flags);
+
+	/* TVDMSRC_DIS */
+	msleep(20);
+
 	/* VDM_SRC is connected to D- and IDP_SINK is connected to D+ */
 	spin_lock_irqsave(&usbmisc->lock, flags);
 	val = readl(usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
@@ -695,7 +705,8 @@ static int imx7d_charger_secondary_detection(struct imx_usbmisc_data *data)
 				usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
 	spin_unlock_irqrestore(&usbmisc->lock, flags);
 
-	usleep_range(1000, 2000);
+	/* TVDMSRC_ON */
+	msleep(40);
 
 	/*
 	 * Per BC 1.2, check voltage of D+:
@@ -798,7 +809,8 @@ static int imx7d_charger_primary_detection(struct imx_usbmisc_data *data)
 				usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
 	spin_unlock_irqrestore(&usbmisc->lock, flags);
 
-	usleep_range(1000, 2000);
+	/* TVDPSRC_ON */
+	msleep(40);
 
 	/* Check if D- is less than VDAT_REF to determine an SDP per BC 1.2 */
 	val = readl(usbmisc->base + MX7D_USB_OTG_PHY_STATUS);
-- 
2.32.0


