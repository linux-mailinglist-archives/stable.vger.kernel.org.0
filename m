Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D52F112176E
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730193AbfLPSf5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:35:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729911AbfLPSH2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:07:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18882206E0;
        Mon, 16 Dec 2019 18:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519647;
        bh=9MaNyCWvJia4kkvMZep4wOiZNAU6Q48KIxe0ZAmr8xI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYlOQr1GwK893hLfUMi1KB/eb0SAyPnAa1VwuCe6/gmjnbHfCAO+qNKF5x0ptpLNz
         PI+0pyF7ND1mTfTXQFd/6qjDcil+HqK1zX3dnqaVHwz1lqnB0S0A3SVt60v1YPCzyU
         A6VuvpmwmBmqkhhd0prlZH4l+ZORB/Y18SfH2eEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nagarjuna Kristam <nkristam@nvidia.com>,
        Jui Chang Kuo <jckuo@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.3 012/180] usb: host: xhci-tegra: Correct phy enable sequence
Date:   Mon, 16 Dec 2019 18:47:32 +0100
Message-Id: <20191216174808.516644047@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174806.018988360@linuxfoundation.org>
References: <20191216174806.018988360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nagarjuna Kristam <nkristam@nvidia.com>

commit 6351653febbb784d86fdf83afe41f7523a61b392 upstream.

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
 drivers/usb/host/xhci-tegra.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -755,7 +755,6 @@ static int tegra_xusb_runtime_suspend(st
 {
 	struct tegra_xusb *tegra = dev_get_drvdata(dev);
 
-	tegra_xusb_phy_disable(tegra);
 	regulator_bulk_disable(tegra->soc->num_supplies, tegra->supplies);
 	tegra_xusb_clk_disable(tegra);
 
@@ -779,16 +778,8 @@ static int tegra_xusb_runtime_resume(str
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
@@ -1181,6 +1172,12 @@ static int tegra_xusb_probe(struct platf
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
@@ -1189,7 +1186,7 @@ static int tegra_xusb_probe(struct platf
 
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to enable device: %d\n", err);
-		goto disable_rpm;
+		goto disable_phy;
 	}
 
 	tegra_xusb_config(tegra, regs);
@@ -1275,9 +1272,11 @@ remove_usb2:
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
@@ -1314,6 +1313,8 @@ static int tegra_xusb_remove(struct plat
 		tegra_xusb_powerdomain_remove(&pdev->dev, tegra);
 	}
 
+	tegra_xusb_phy_disable(tegra);
+
 	tegra_xusb_padctl_put(tegra->padctl);
 
 	return 0;


