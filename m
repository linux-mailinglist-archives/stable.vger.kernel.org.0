Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39CC6DA18
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbfGSD7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 23:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728543AbfGSD7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA0D521852;
        Fri, 19 Jul 2019 03:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508751;
        bh=dFjx6SYhIGvhPMZ2Z3/ULBmQ8XVIK4WXF63iZ1aAseE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ldJgndeEqQceHXqubdb0VMYL8C4fNPgED5qfxzfjUZvTe2V3T+Jgd8IdbdKUtVbvR
         hAT1hTIIYZFKvM7uh/RLqIgbCFmaNfJCwxgmKjEbP4A+Vpyemde0hGaXUFZMLZXGBk
         C2+o1nImY7l4F/vubzuT8b5Opj+Fvmdzd6r1OVmw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 070/171] usb: dwc3: Fix core validation in probe, move after clocks are enabled
Date:   Thu, 18 Jul 2019 23:55:01 -0400
Message-Id: <20190719035643.14300-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enric Balletbo i Serra <enric.balletbo@collabora.com>

[ Upstream commit dc1b5d9aed1794b5a1c6b0da46e372cc09974cbc ]

The required clocks needs to be enabled before the first register
access. After commit fe8abf332b8f ("usb: dwc3: support clocks and resets
for DWC3 core"), this happens when the dwc3_core_is_valid function is
called, but the mentioned commit adds that call in the wrong place,
before the clocks are enabled. So, move that call after the
clk_bulk_enable() to ensure the clocks are enabled and the reset
deasserted.

I detected this while, as experiment, I tried to move the clocks and resets
from the glue layer to the DWC3 core on a Samsung Chromebook Plus.

That was not detected before because, in most cases, the glue layer
initializes SoC-specific things and then populates the child "snps,dwc3"
with those clocks already enabled.

Fixes: b873e2d0ea1ef ("usb: dwc3: Do core validation early on probe")
Signed-off-by: Enric Balletbo i Serra <enric.balletbo@collabora.com>
Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 4aff1d8dbc4f..6e9e172010fc 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -1423,11 +1423,6 @@ static int dwc3_probe(struct platform_device *pdev)
 	dwc->regs	= regs;
 	dwc->regs_size	= resource_size(&dwc_res);
 
-	if (!dwc3_core_is_valid(dwc)) {
-		dev_err(dwc->dev, "this is not a DesignWare USB3 DRD Core\n");
-		return -ENODEV;
-	}
-
 	dwc3_get_properties(dwc);
 
 	dwc->reset = devm_reset_control_get_optional_shared(dev, NULL);
@@ -1460,6 +1455,12 @@ static int dwc3_probe(struct platform_device *pdev)
 	if (ret)
 		goto unprepare_clks;
 
+	if (!dwc3_core_is_valid(dwc)) {
+		dev_err(dwc->dev, "this is not a DesignWare USB3 DRD Core\n");
+		ret = -ENODEV;
+		goto disable_clks;
+	}
+
 	platform_set_drvdata(pdev, dwc);
 	dwc3_cache_hwparams(dwc);
 
@@ -1525,6 +1526,7 @@ static int dwc3_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+disable_clks:
 	clk_bulk_disable(dwc->num_clks, dwc->clks);
 unprepare_clks:
 	clk_bulk_unprepare(dwc->num_clks, dwc->clks);
-- 
2.20.1

