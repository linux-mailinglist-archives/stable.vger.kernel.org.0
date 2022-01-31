Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD14A44BB
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358682AbiAaLcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379110AbiAaL3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:29:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2966C0617A3;
        Mon, 31 Jan 2022 03:19:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 534D060FF0;
        Mon, 31 Jan 2022 11:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D050C340E8;
        Mon, 31 Jan 2022 11:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627955;
        bh=lAg1e2oPaAdy0h+YKy48zIGdGuDhjdDaxDk/g/xpYQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpuW2d+IIoBDieAS+W+PG3RfHc8pz1IlPXwNHBXigs4YoH8mPQ5A9OgKhrLWY5e0K
         5fbr2Unon6AzdLStlTM0g68rbB3s0LkSdJftYpAGiW1P4jgq7WM7f18GfviOJWEVSV
         dj60Ff1xNY5nMC3mAcCl7O5PCSTBaw8Q6L7HkRos=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH 5.16 078/200] usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0 mode
Date:   Mon, 31 Jan 2022 11:55:41 +0100
Message-Id: <20220131105236.226828088@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hancock <robert.hancock@calian.com>

commit 9678f3361afc27a3124cd2824aec0227739986fb upstream.

It appears that the PIPE clock should not be selected when only USB 2.0
is being used in the design and no USB 3.0 reference clock is used.
Also, the core resets are not required if a USB3 PHY is not in use, and
will break things if USB3 is actually used but the PHY entry is not
listed in the device tree.

Skip core resets and register settings that are only required for
USB3 mode when no USB3 PHY is specified in the device tree.

Fixes: 84770f028fab ("usb: dwc3: Add driver for Xilinx platforms")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220126000253.1586760-2-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -110,6 +110,18 @@ static int dwc3_xlnx_init_zynqmp(struct
 		usb3_phy = NULL;
 	}
 
+	/*
+	 * The following core resets are not required unless a USB3 PHY
+	 * is used, and the subsequent register settings are not required
+	 * unless a core reset is performed (they should be set properly
+	 * by the first-stage boot loader, but may be reverted by a core
+	 * reset). They may also break the configuration if USB3 is actually
+	 * in use but the usb3-phy entry is missing from the device tree.
+	 * Therefore, skip these operations in this case.
+	 */
+	if (!usb3_phy)
+		goto skip_usb3_phy;
+
 	crst = devm_reset_control_get_exclusive(dev, "usb_crst");
 	if (IS_ERR(crst)) {
 		ret = PTR_ERR(crst);
@@ -188,6 +200,7 @@ static int dwc3_xlnx_init_zynqmp(struct
 		goto err;
 	}
 
+skip_usb3_phy:
 	/*
 	 * This routes the USB DMA traffic to go through FPD path instead
 	 * of reaching DDR directly. This traffic routing is needed to


