Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98B2207538
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 16:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390920AbgFXOFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 10:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389668AbgFXOFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 10:05:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B6CC20781;
        Wed, 24 Jun 2020 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593007513;
        bh=5Zc6yJIuVvIa+ic+NBVP+ADNi9Fkjydk5nGT98cShIM=;
        h=Subject:To:From:Date:From;
        b=e0Itjdivzo8OutAy4GrX0OcMzirivaien1pGDRC8XggKRraCkQPFuGUJBrjYmAZOG
         3Sfoti0elt+JDWBzbk3UHu46hpsvW7v+1PKIhwMgAn6hYfSQ9gRhNt/GCzhyF/gc7k
         a9m//v3ub0NWN00pRilF1OjvxhJkeBzrMBW6/IVs=
Subject: patch "Revert "usb: dwc3: exynos: Add support for Exynos5422 suspend clk"" added to usb-linus
To:     linux.amoon@gmail.com, balbi@kernel.org,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 24 Jun 2020 16:05:11 +0200
Message-ID: <159300751183242@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Revert "usb: dwc3: exynos: Add support for Exynos5422 suspend clk"

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From ad38beb373a14e082f4e64b68c0b6e6b09764680 Mon Sep 17 00:00:00 2001
From: Anand Moon <linux.amoon@gmail.com>
Date: Tue, 23 Jun 2020 07:46:37 +0000
Subject: Revert "usb: dwc3: exynos: Add support for Exynos5422 suspend clk"

This reverts commit 07f6842341abe978e6375078f84506ec3280ece5.

Since SCLK_SCLK_USBD300 suspend clock need to be configured
for phy module, I wrongly mapped this clock to DWC3 code.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Cc: stable <stable@vger.kernel.org>
Fixes: 07f6842341ab ("usb: dwc3: exynos: Add support for Exynos5422 suspend clk")
Link: https://lore.kernel.org/r/20200623074637.756-1-linux.amoon@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/dwc3-exynos.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 48b68b6f0dc8..90bb022737da 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -162,12 +162,6 @@ static const struct dwc3_exynos_driverdata exynos5250_drvdata = {
 	.suspend_clk_idx = -1,
 };
 
-static const struct dwc3_exynos_driverdata exynos5420_drvdata = {
-	.clk_names = { "usbdrd30", "usbdrd30_susp_clk"},
-	.num_clks = 2,
-	.suspend_clk_idx = 1,
-};
-
 static const struct dwc3_exynos_driverdata exynos5433_drvdata = {
 	.clk_names = { "aclk", "susp_clk", "pipe_pclk", "phyclk" },
 	.num_clks = 4,
@@ -184,9 +178,6 @@ static const struct of_device_id exynos_dwc3_match[] = {
 	{
 		.compatible = "samsung,exynos5250-dwusb3",
 		.data = &exynos5250_drvdata,
-	}, {
-		.compatible = "samsung,exynos5420-dwusb3",
-		.data = &exynos5420_drvdata,
 	}, {
 		.compatible = "samsung,exynos5433-dwusb3",
 		.data = &exynos5433_drvdata,
-- 
2.27.0


