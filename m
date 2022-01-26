Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308D849CA0A
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbiAZMtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:49:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54348 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiAZMtr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:49:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8D7961A27
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 12:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851CBC340E3;
        Wed, 26 Jan 2022 12:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643201386;
        bh=pJ2KOjinqHgkrvNtGn5Su33qoPXZMArr3UGIoXolYBI=;
        h=Subject:To:From:Date:From;
        b=00V59RDXcOQY4UlYvY+X4IfvOkACbHrxlSItYP20e/79UIxcZcA5xGAb11VTUxk+x
         TST04ii7UllB9fQ4IJhJiQ5TT60726ihNg/bpE+cTTUArca+8qywD7kDcqO3o+3iPj
         f3VOd4dp56OCX1DsXjwjNy/59Oax8KwZ3/1wM8OE=
Subject: patch "usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0" added to usb-linus
To:     robert.hancock@calian.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 13:49:43 +0100
Message-ID: <164320138313522@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 9678f3361afc27a3124cd2824aec0227739986fb Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Tue, 25 Jan 2022 18:02:50 -0600
Subject: usb: dwc3: xilinx: Skip resets and USB3 register settings for USB2.0
 mode

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
 drivers/usb/dwc3/dwc3-xilinx.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-xilinx.c b/drivers/usb/dwc3/dwc3-xilinx.c
index 9cc3ad701a29..06b591b14b09 100644
--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -110,6 +110,18 @@ static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
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
@@ -188,6 +200,7 @@ static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
 		goto err;
 	}
 
+skip_usb3_phy:
 	/*
 	 * This routes the USB DMA traffic to go through FPD path instead
 	 * of reaching DDR directly. This traffic routing is needed to
-- 
2.35.0


