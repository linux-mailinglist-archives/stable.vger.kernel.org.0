Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F00028246C
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 16:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725794AbgJCOCq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 10:02:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:57546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725790AbgJCOCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Oct 2020 10:02:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0326206CD;
        Sat,  3 Oct 2020 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601733766;
        bh=wL5Px0EB5AR2lxwtHwvp3MsnrcU5RBqDbLar6a41Cso=;
        h=Subject:To:From:Date:From;
        b=HB0d3FHyRuFvg+lgk6wUTFxwMxxq94oNtkRslt3ofBTV3myD07n7cdPoqAnhUgOCj
         KsZ02TUrGdFIDOvZjdz8QEV7EFVrjCBiZz5f3fIpEUN73zmMc35ZW7PMYAgZ7qgYUd
         TpB1ODdnG4boBGbpVBfNFn+peN7phAajgQao8a6I=
Subject: patch "usb: dwc3: core: add phy cleanup for probe error handling" added to usb-testing
To:     jun.li@nxp.com, balbi@kernel.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Oct 2020 16:01:24 +0200
Message-ID: <1601733684252168@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: dwc3: core: add phy cleanup for probe error handling

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 03c1fd622f72c7624c81b64fdba4a567ae5ee9cb Mon Sep 17 00:00:00 2001
From: Li Jun <jun.li@nxp.com>
Date: Tue, 28 Jul 2020 20:42:41 +0800
Subject: usb: dwc3: core: add phy cleanup for probe error handling

Add the phy cleanup if dwc3 mode init fail, which is the missing part of
de-init for dwc3 core init.

Fixes: c499ff71ff2a ("usb: dwc3: core: re-factor init and exit paths")
Cc: <stable@vger.kernel.org>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
---
 drivers/usb/dwc3/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 24fba4ca3d12..385262f6747d 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1564,6 +1564,17 @@ static int dwc3_probe(struct platform_device *pdev)
 
 err5:
 	dwc3_event_buffers_cleanup(dwc);
+
+	usb_phy_shutdown(dwc->usb2_phy);
+	usb_phy_shutdown(dwc->usb3_phy);
+	phy_exit(dwc->usb2_generic_phy);
+	phy_exit(dwc->usb3_generic_phy);
+
+	usb_phy_set_suspend(dwc->usb2_phy, 1);
+	usb_phy_set_suspend(dwc->usb3_phy, 1);
+	phy_power_off(dwc->usb2_generic_phy);
+	phy_power_off(dwc->usb3_generic_phy);
+
 	dwc3_ulpi_exit(dwc);
 
 err4:
-- 
2.28.0


