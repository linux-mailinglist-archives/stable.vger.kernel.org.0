Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E22B4454817
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236982AbhKQOGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:06:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:60536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236978AbhKQOGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:06:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78EDD6139F;
        Wed, 17 Nov 2021 14:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637157802;
        bh=WTw6d28/oKJN74Vqe5thMAibUFmHNIryFHzxMo9dy/U=;
        h=Subject:To:From:Date:From;
        b=g9P6rBYjU/Mc7ghclFOPrlTNN6SVQz982wuCjLGyN27+dPozUp/07EILSiL7RQFeW
         0D7cz63JNp74nXUArV5WBvAdkgdFB/WUhGY9A3RIEjz/dBlEQy2rd7cc5qSxlf3ukd
         ndI+R07TF+zzkrFcnd2JCKSeKfJsSVB51mhbBA9o=
Subject: patch "usb: xhci: tegra: Check padctrl interrupt presence in device tree" added to usb-linus
To:     digetx@gmail.com, gregkh@linuxfoundation.org, kwizart@gmail.com,
        stable@vger.kernel.org, thomas.graichen@gmail.com,
        treding@nvidia.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 17 Nov 2021 15:03:08 +0100
Message-ID: <1637157788221157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    usb: xhci: tegra: Check padctrl interrupt presence in device tree

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 51f2246158f686c881859f4b620f831f06e296e1 Mon Sep 17 00:00:00 2001
From: Dmitry Osipenko <digetx@gmail.com>
Date: Mon, 8 Nov 2021 01:44:55 +0300
Subject: usb: xhci: tegra: Check padctrl interrupt presence in device tree

Older device-trees don't specify padctrl interrupt and xhci-tegra driver
now fails to probe with -EINVAL using those device-trees. Check interrupt
presence and keep runtime PM disabled if it's missing to fix the trouble.

Fixes: 971ee247060d ("usb: xhci: tegra: Enable ELPG for runtime/system PM")
Cc: <stable@vger.kernel.org> # 5.14+
Reported-by: Nicolas Chauvet <kwizart@gmail.com>
Tested-by: Nicolas Chauvet <kwizart@gmail.com> # T124 TK1
Tested-by: Thomas Graichen <thomas.graichen@gmail.com> # T124 Nyan Big
Tested-by: Thierry Reding <treding@nvidia.com> # Tegra CI
Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211107224455.10359-1-digetx@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-tegra.c | 41 +++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 1bf494b649bd..c8af2cd2216d 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1400,6 +1400,7 @@ static void tegra_xusb_deinit_usb_phy(struct tegra_xusb *tegra)
 
 static int tegra_xusb_probe(struct platform_device *pdev)
 {
+	struct of_phandle_args args;
 	struct tegra_xusb *tegra;
 	struct device_node *np;
 	struct resource *regs;
@@ -1454,10 +1455,17 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 		goto put_padctl;
 	}
 
-	tegra->padctl_irq = of_irq_get(np, 0);
-	if (tegra->padctl_irq <= 0) {
-		err = (tegra->padctl_irq == 0) ? -ENODEV : tegra->padctl_irq;
-		goto put_padctl;
+	/* Older device-trees don't have padctrl interrupt */
+	err = of_irq_parse_one(np, 0, &args);
+	if (!err) {
+		tegra->padctl_irq = of_irq_get(np, 0);
+		if (tegra->padctl_irq <= 0) {
+			err = (tegra->padctl_irq == 0) ? -ENODEV : tegra->padctl_irq;
+			goto put_padctl;
+		}
+	} else {
+		dev_dbg(&pdev->dev,
+			"%pOF is missing an interrupt, disabling PM support\n", np);
 	}
 
 	tegra->host_clk = devm_clk_get(&pdev->dev, "xusb_host");
@@ -1696,11 +1704,15 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 		goto remove_usb3;
 	}
 
-	err = devm_request_threaded_irq(&pdev->dev, tegra->padctl_irq, NULL, tegra_xusb_padctl_irq,
-					IRQF_ONESHOT, dev_name(&pdev->dev), tegra);
-	if (err < 0) {
-		dev_err(&pdev->dev, "failed to request padctl IRQ: %d\n", err);
-		goto remove_usb3;
+	if (tegra->padctl_irq) {
+		err = devm_request_threaded_irq(&pdev->dev, tegra->padctl_irq,
+						NULL, tegra_xusb_padctl_irq,
+						IRQF_ONESHOT, dev_name(&pdev->dev),
+						tegra);
+		if (err < 0) {
+			dev_err(&pdev->dev, "failed to request padctl IRQ: %d\n", err);
+			goto remove_usb3;
+		}
 	}
 
 	err = tegra_xusb_enable_firmware_messages(tegra);
@@ -1718,13 +1730,16 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 	/* Enable wake for both USB 2.0 and USB 3.0 roothubs */
 	device_init_wakeup(&tegra->hcd->self.root_hub->dev, true);
 	device_init_wakeup(&xhci->shared_hcd->self.root_hub->dev, true);
-	device_init_wakeup(tegra->dev, true);
 
 	pm_runtime_use_autosuspend(tegra->dev);
 	pm_runtime_set_autosuspend_delay(tegra->dev, 2000);
 	pm_runtime_mark_last_busy(tegra->dev);
 	pm_runtime_set_active(tegra->dev);
-	pm_runtime_enable(tegra->dev);
+
+	if (tegra->padctl_irq) {
+		device_init_wakeup(tegra->dev, true);
+		pm_runtime_enable(tegra->dev);
+	}
 
 	return 0;
 
@@ -1772,7 +1787,9 @@ static int tegra_xusb_remove(struct platform_device *pdev)
 	dma_free_coherent(&pdev->dev, tegra->fw.size, tegra->fw.virt,
 			  tegra->fw.phys);
 
-	pm_runtime_disable(&pdev->dev);
+	if (tegra->padctl_irq)
+		pm_runtime_disable(&pdev->dev);
+
 	pm_runtime_put(&pdev->dev);
 
 	tegra_xusb_powergate_partitions(tegra);
-- 
2.34.0


