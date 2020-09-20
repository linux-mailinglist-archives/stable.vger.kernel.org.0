Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B6C271811
	for <lists+stable@lfdr.de>; Sun, 20 Sep 2020 23:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgITVMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Sep 2020 17:12:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbgITVMy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 20 Sep 2020 17:12:54 -0400
Received: from localhost.localdomain (unknown [194.230.155.191])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECB3720829;
        Sun, 20 Sep 2020 21:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600636373;
        bh=OFg8udfCfwBzHEhbuaN6LUxKWixXaUOIv34Fpv3yvaQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Ja4F9Vfw+sO1MQwL3z/jS6chdVbL+hX9+RBtKYIJnGaeyzkxlR4OhWcHid45ZGlig
         3ZwKdPLMEuC42u4POfpMTLBSx3E4pTGYnYqXQT/88oH9Sx8SKsoIVmFPMr7C7d4Py+
         S0xmIsuhOf2WL738wVViFCXE/UrE/xyWyZwP5Lx8=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3] i2c: imx: Fix external abort on interrupt in exit paths
Date:   Sun, 20 Sep 2020 23:12:38 +0200
Message-Id: <20200920211238.13920-1-krzk@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If interrupt comes late, during probe error path or device remove (could
be triggered with CONFIG_DEBUG_SHIRQ), the interrupt handler
i2c_imx_isr() will access registers with the clock being disabled.  This
leads to external abort on non-linefetch on Toradex Colibri VF50 module
(with Vybrid VF5xx):

    Unhandled fault: external abort on non-linefetch (0x1008) at 0x8882d003
    Internal error: : 1008 [#1] ARM
    Modules linked in:
    CPU: 0 PID: 1 Comm: swapper Not tainted 5.7.0 #607
    Hardware name: Freescale Vybrid VF5xx/VF6xx (Device Tree)
      (i2c_imx_isr) from [<8017009c>] (free_irq+0x25c/0x3b0)
      (free_irq) from [<805844ec>] (release_nodes+0x178/0x284)
      (release_nodes) from [<80580030>] (really_probe+0x10c/0x348)
      (really_probe) from [<80580380>] (driver_probe_device+0x60/0x170)
      (driver_probe_device) from [<80580630>] (device_driver_attach+0x58/0x60)
      (device_driver_attach) from [<805806bc>] (__driver_attach+0x84/0xc0)
      (__driver_attach) from [<8057e228>] (bus_for_each_dev+0x68/0xb4)
      (bus_for_each_dev) from [<8057f3ec>] (bus_add_driver+0x144/0x1ec)
      (bus_add_driver) from [<80581320>] (driver_register+0x78/0x110)
      (driver_register) from [<8010213c>] (do_one_initcall+0xa8/0x2f4)
      (do_one_initcall) from [<80c0100c>] (kernel_init_freeable+0x178/0x1dc)
      (kernel_init_freeable) from [<80807048>] (kernel_init+0x8/0x110)
      (kernel_init) from [<80100114>] (ret_from_fork+0x14/0x20)

Additionally, the i2c_imx_isr() could wake up the wait queue
(imx_i2c_struct->queue) before its initialization happens.

The resource-managed framework should not be used for interrupt handling,
because the resource will be released too late - after disabling clocks.
The interrupt handler is not prepared for such case.

Fixes: 1c4b6c3bcf30 ("i2c: imx: implement bus recovery")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

---

Changes since v2:
1. Rebase

Changes since v1:
1. Remove the devm- and use regular methods.
---
 drivers/i2c/busses/i2c-imx.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 63f4367c312b..c98529c76348 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1169,14 +1169,6 @@ static int i2c_imx_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	/* Request IRQ */
-	ret = devm_request_irq(&pdev->dev, irq, i2c_imx_isr, IRQF_SHARED,
-				pdev->name, i2c_imx);
-	if (ret) {
-		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
-		goto clk_disable;
-	}
-
 	/* Init queue */
 	init_waitqueue_head(&i2c_imx->queue);
 
@@ -1195,6 +1187,14 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto rpm_disable;
 
+	/* Request IRQ */
+	ret = request_threaded_irq(irq, i2c_imx_isr, NULL, IRQF_SHARED,
+				   pdev->name, i2c_imx);
+	if (ret) {
+		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
+		goto rpm_disable;
+	}
+
 	/* Set up clock divider */
 	i2c_imx->bitrate = I2C_MAX_STANDARD_MODE_FREQ;
 	ret = of_property_read_u32(pdev->dev.of_node,
@@ -1237,13 +1237,12 @@ static int i2c_imx_probe(struct platform_device *pdev)
 
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	free_irq(irq, i2c_imx);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-
-clk_disable:
 	clk_disable_unprepare(i2c_imx->clk);
 	return ret;
 }
@@ -1251,7 +1250,7 @@ static int i2c_imx_probe(struct platform_device *pdev)
 static int i2c_imx_remove(struct platform_device *pdev)
 {
 	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
-	int ret;
+	int irq, ret;
 
 	ret = pm_runtime_get_sync(&pdev->dev);
 	if (ret < 0)
@@ -1271,6 +1270,9 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
 
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	irq = platform_get_irq(pdev, 0);
+	if (irq >= 0)
+		free_irq(irq, i2c_imx);
 	clk_disable_unprepare(i2c_imx->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);
-- 
2.17.1

