Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAF23AF049
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbhFUQr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:47:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233902AbhFUQpp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:45:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9ACB613D1;
        Mon, 21 Jun 2021 16:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293168;
        bh=7D5+Z7yqnTuz20Rw2xK/398Z00a3m+DNXkDvvgn3+nQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfr2X/taMNB2+BFOlqySd6yN7wLJR8zBDktu5RBCDpY5p5qZGuT1jQ4MTrLBw+VZV
         fiusNP567lg7Pq9zJMRP9Z5jJf8fIR4dHDiwRXheJQR+twNOrgHg4bEu8St/+v1O2+
         77M9stAlx6iP0iI2OHSL9+JxI1brBrRp3MiCKV4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Breno Lima <breno.lima@nxp.com>,
        Jun Li <jun.li@nxp.com>, Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 5.12 122/178] usb: chipidea: imx: Fix Battery Charger 1.2 CDP detection
Date:   Mon, 21 Jun 2021 18:15:36 +0200
Message-Id: <20210621154926.925404166@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Breno Lima <breno.lima@nxp.com>

commit c6d580d96f140596d69220f60ce0cfbea4ee5c0f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/usbmisc_imx.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/usb/chipidea/usbmisc_imx.c
+++ b/drivers/usb/chipidea/usbmisc_imx.c
@@ -686,6 +686,16 @@ static int imx7d_charger_secondary_detec
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
@@ -695,7 +705,8 @@ static int imx7d_charger_secondary_detec
 				usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
 	spin_unlock_irqrestore(&usbmisc->lock, flags);
 
-	usleep_range(1000, 2000);
+	/* TVDMSRC_ON */
+	msleep(40);
 
 	/*
 	 * Per BC 1.2, check voltage of D+:
@@ -798,7 +809,8 @@ static int imx7d_charger_primary_detecti
 				usbmisc->base + MX7D_USB_OTG_PHY_CFG2);
 	spin_unlock_irqrestore(&usbmisc->lock, flags);
 
-	usleep_range(1000, 2000);
+	/* TVDPSRC_ON */
+	msleep(40);
 
 	/* Check if D- is less than VDAT_REF to determine an SDP per BC 1.2 */
 	val = readl(usbmisc->base + MX7D_USB_OTG_PHY_STATUS);


