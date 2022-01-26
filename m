Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3E649CA0D
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:49:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiAZMtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:49:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54404 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241519AbiAZMtz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:49:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3215F61A27
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 12:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB79C340E3;
        Wed, 26 Jan 2022 12:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643201394;
        bh=BsAFGJ+t3AdK3q2XgtlHPjfjLDcuOiRdH0XyaLRnJDw=;
        h=Subject:To:From:Date:From;
        b=2gH0pdsLR9g54ukG59rnlSwCxfeqv0U2IDGGf1Q900Ecq21y73SaSCbijRtkpLG8m
         XW63OgqzoiAH54tuMch2Sywcz8Ca9AEEWhlMiAI1HPdhzy/tPdcwy3b0AmKjAGVoib
         trowmfTDpG/W6TgZiJbRd0yEp1J0YhDS/yME0Sag=
Subject: patch "usb: dwc3: xilinx: Fix error handling when getting USB3 PHY" added to usb-linus
To:     robert.hancock@calian.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 26 Jan 2022 13:49:43 +0100
Message-ID: <16432013837947@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: xilinx: Fix error handling when getting USB3 PHY

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2cc9b1c93b1c4caa2d971856c0780fb5f7d04692 Mon Sep 17 00:00:00 2001
From: Robert Hancock <robert.hancock@calian.com>
Date: Tue, 25 Jan 2022 18:02:51 -0600
Subject: usb: dwc3: xilinx: Fix error handling when getting USB3 PHY

The code that looked up the USB3 PHY was ignoring all errors other than
EPROBE_DEFER in an attempt to handle the PHY not being present. Fix and
simplify the code by using devm_phy_optional_get and dev_err_probe so
that a missing PHY is not treated as an error and unexpected errors
are handled properly.

Fixes: 84770f028fab ("usb: dwc3: Add driver for Xilinx platforms")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
Link: https://lore.kernel.org/r/20220126000253.1586760-3-robert.hancock@calian.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-xilinx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-xilinx.c b/drivers/usb/dwc3/dwc3-xilinx.c
index 06b591b14b09..e14ac15e24c3 100644
--- a/drivers/usb/dwc3/dwc3-xilinx.c
+++ b/drivers/usb/dwc3/dwc3-xilinx.c
@@ -102,12 +102,12 @@ static int dwc3_xlnx_init_zynqmp(struct dwc3_xlnx *priv_data)
 	int			ret;
 	u32			reg;
 
-	usb3_phy = devm_phy_get(dev, "usb3-phy");
-	if (PTR_ERR(usb3_phy) == -EPROBE_DEFER) {
-		ret = -EPROBE_DEFER;
+	usb3_phy = devm_phy_optional_get(dev, "usb3-phy");
+	if (IS_ERR(usb3_phy)) {
+		ret = PTR_ERR(usb3_phy);
+		dev_err_probe(dev, ret,
+			      "failed to get USB3 PHY\n");
 		goto err;
-	} else if (IS_ERR(usb3_phy)) {
-		usb3_phy = NULL;
 	}
 
 	/*
-- 
2.35.0


