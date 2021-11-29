Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB21461EB7
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379036AbhK2Sje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:39:34 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42250 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378594AbhK2Shd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:37:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CA3B815DD;
        Mon, 29 Nov 2021 18:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5620EC53FAD;
        Mon, 29 Nov 2021 18:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210852;
        bh=ifJp1A4joxMqI8BzSIDLgJ1AH24pBipRR+hTi0ZkCRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihp/9NGm41dk5Ha2lVfsBELCegPvAqapYQSFr3Zjcu/HLrdFmziXLXxXn7zZ238vl
         4jyOtZr0mtqm7m2rYLQzAGr1u/vQwlu7RGFI/ppNXP4aVAwBoW5rBG7XMUDVtptfB7
         vqA1Mi6rJlDlPIzOWl/5Xph5Od2iHDP8rxfHgLu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Chauvet <kwizart@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thomas Graichen <thomas.graichen@gmail.com>
Subject: [PATCH 5.15 018/179] usb: xhci: tegra: Check padctrl interrupt presence in device tree
Date:   Mon, 29 Nov 2021 19:16:52 +0100
Message-Id: <20211129181719.549470457@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

commit 51f2246158f686c881859f4b620f831f06e296e1 upstream.

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
 drivers/usb/host/xhci-tegra.c |   41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1400,6 +1400,7 @@ static void tegra_xusb_deinit_usb_phy(st
 
 static int tegra_xusb_probe(struct platform_device *pdev)
 {
+	struct of_phandle_args args;
 	struct tegra_xusb *tegra;
 	struct device_node *np;
 	struct resource *regs;
@@ -1454,10 +1455,17 @@ static int tegra_xusb_probe(struct platf
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
@@ -1696,11 +1704,15 @@ static int tegra_xusb_probe(struct platf
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
@@ -1718,13 +1730,16 @@ static int tegra_xusb_probe(struct platf
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
 
@@ -1772,7 +1787,9 @@ static int tegra_xusb_remove(struct plat
 	dma_free_coherent(&pdev->dev, tegra->fw.size, tegra->fw.virt,
 			  tegra->fw.phys);
 
-	pm_runtime_disable(&pdev->dev);
+	if (tegra->padctl_irq)
+		pm_runtime_disable(&pdev->dev);
+
 	pm_runtime_put(&pdev->dev);
 
 	tegra_xusb_powergate_partitions(tegra);


