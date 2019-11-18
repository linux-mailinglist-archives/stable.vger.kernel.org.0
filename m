Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 931D2100444
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 12:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbfKRLea (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 06:34:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:46054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726461AbfKRLea (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 06:34:30 -0500
Received: from localhost (unknown [89.205.134.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A06ED2067D;
        Mon, 18 Nov 2019 11:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574076869;
        bh=gQlCyTjE30wnCbwVvCUYG8/YhmuKpC9hKBzRZAqxv2Y=;
        h=Subject:To:From:Date:From;
        b=0ldbrbgmPwflLu/odEaanEK8/sFA1FdxeRbLNOfIpMZVfS4XlYxgo06/bOOO0o9e3
         uMk9dNc4ECOAu1n8febDKJh7fKyyzjt1GiUJa6ifYn2/7KQEvj3pDEQM3EeWW+AihG
         TRlEWRJ+esgK75tiKBpt+GxNe9q4Ie2xm3Sf55f0=
Subject: patch "usb: host: xhci-tegra: Correct phy enable sequence" added to usb-testing
To:     nkristam@nvidia.com, gregkh@linuxfoundation.org, jckuo@nvidia.com,
        jonathanh@nvidia.com, stable@vger.kernel.org, treding@nvidia.com
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Nov 2019 12:34:26 +0100
Message-ID: <1574076866236245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: host: xhci-tegra: Correct phy enable sequence

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the usb-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


From 6351653febbb784d86fdf83afe41f7523a61b392 Mon Sep 17 00:00:00 2001
From: Nagarjuna Kristam <nkristam@nvidia.com>
Date: Mon, 4 Nov 2019 14:54:30 +0530
Subject: usb: host: xhci-tegra: Correct phy enable sequence

XUSB phy needs to be enabled before un-powergating the power partitions.
However in the current sequence, it happens opposite. Correct the phy
enable and powergating partition sequence to avoid any boot hangs.

Signed-off-by: Nagarjuna Kristam <nkristam@nvidia.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Jui Chang Kuo <jckuo@nvidia.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/1572859470-7823-1-git-send-email-nkristam@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 540b47a99824..bf9065438320 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -763,7 +763,6 @@ static int tegra_xusb_runtime_suspend(struct device *dev)
 {
 	struct tegra_xusb *tegra = dev_get_drvdata(dev);
 
-	tegra_xusb_phy_disable(tegra);
 	regulator_bulk_disable(tegra->soc->num_supplies, tegra->supplies);
 	tegra_xusb_clk_disable(tegra);
 
@@ -787,16 +786,8 @@ static int tegra_xusb_runtime_resume(struct device *dev)
 		goto disable_clk;
 	}
 
-	err = tegra_xusb_phy_enable(tegra);
-	if (err < 0) {
-		dev_err(dev, "failed to enable PHYs: %d\n", err);
-		goto disable_regulator;
-	}
-
 	return 0;
 
-disable_regulator:
-	regulator_bulk_disable(tegra->soc->num_supplies, tegra->supplies);
 disable_clk:
 	tegra_xusb_clk_disable(tegra);
 	return err;
@@ -1188,6 +1179,12 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 	 */
 	platform_set_drvdata(pdev, tegra);
 
+	err = tegra_xusb_phy_enable(tegra);
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to enable PHYs: %d\n", err);
+		goto put_hcd;
+	}
+
 	pm_runtime_enable(&pdev->dev);
 	if (pm_runtime_enabled(&pdev->dev))
 		err = pm_runtime_get_sync(&pdev->dev);
@@ -1196,7 +1193,7 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to enable device: %d\n", err);
-		goto disable_rpm;
+		goto disable_phy;
 	}
 
 	tegra_xusb_config(tegra, regs);
@@ -1282,9 +1279,11 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 put_rpm:
 	if (!pm_runtime_status_suspended(&pdev->dev))
 		tegra_xusb_runtime_suspend(&pdev->dev);
-disable_rpm:
-	pm_runtime_disable(&pdev->dev);
+put_hcd:
 	usb_put_hcd(tegra->hcd);
+disable_phy:
+	tegra_xusb_phy_disable(tegra);
+	pm_runtime_disable(&pdev->dev);
 put_powerdomains:
 	if (!of_property_read_bool(pdev->dev.of_node, "power-domains")) {
 		tegra_powergate_power_off(TEGRA_POWERGATE_XUSBC);
@@ -1321,6 +1320,8 @@ static int tegra_xusb_remove(struct platform_device *pdev)
 		tegra_xusb_powerdomain_remove(&pdev->dev, tegra);
 	}
 
+	tegra_xusb_phy_disable(tegra);
+
 	tegra_xusb_padctl_put(tegra->padctl);
 
 	return 0;
-- 
2.24.0


