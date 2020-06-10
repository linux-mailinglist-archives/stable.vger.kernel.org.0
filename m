Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 113111F5618
	for <lists+stable@lfdr.de>; Wed, 10 Jun 2020 15:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgFJNqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 09:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:40986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgFJNqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Jun 2020 09:46:54 -0400
Received: from PC-kkoz.proceq.com (unknown [213.160.61.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1614D20734;
        Wed, 10 Jun 2020 13:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591796813;
        bh=ySu/M96+t17yNUSK2ZVv+Yrxj6RgjYRwsF77Zozd3Gk=;
        h=From:To:Cc:Subject:Date:From;
        b=kabpzzP8emaF3CzGqvm/lJhyhiuL9v+rC3MsEerpO13T6RFyuFGsSEwLJ9FQEz5gg
         Ulssu7K/SrZYKjRbtG4RTC+nGA/0e5Lok3oKGxFNxy06PgTINst0leAuG+Ektxb9SS
         oIBT3AQvCY2EP198+Xx4X+Z5cdaHLFJjbFUJ42yI=
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Gao Pan <b54642@freescale.com>,
        Fugang Duan <B38611@freescale.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] i2c: imx: Fix external abort on early interrupt
Date:   Wed, 10 Jun 2020 15:46:42 +0200
Message-Id: <1591796802-23504-1-git-send-email-krzk@kernel.org>
X-Mailer: git-send-email 2.7.4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If interrupt comes early (could be triggered with CONFIG_DEBUG_SHIRQ),
the i2c_imx_isr() will access registers before the I2C hardware is
initialized.  This leads to external abort on non-linefetch on Toradex
Colibri VF50 module (with Vybrid VF5xx):

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

Fixes: 1c4b6c3bcf30 ("i2c: imx: implement bus recovery")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 0ab5381aa012..e28a39f4840f 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1171,14 +1171,6 @@ static int i2c_imx_probe(struct platform_device *pdev)
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
 
@@ -1223,6 +1215,14 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto clk_notifier_unregister;
 
+	/* Request IRQ */
+	ret = devm_request_irq(&pdev->dev, irq, i2c_imx_isr, IRQF_SHARED,
+				pdev->name, i2c_imx);
+	if (ret) {
+		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
+		goto i2c_del_adapter;
+	}
+
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(&pdev->dev);
 
@@ -1237,6 +1237,8 @@ static int i2c_imx_probe(struct platform_device *pdev)
 
 	return 0;   /* Return OK */
 
+i2c_del_adapter:
+	i2c_del_adapter(&i2c_imx->adapter);
 clk_notifier_unregister:
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
 rpm_disable:
@@ -1244,8 +1246,6 @@ static int i2c_imx_probe(struct platform_device *pdev)
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
-
-clk_disable:
 	clk_disable_unprepare(i2c_imx->clk);
 	return ret;
 }
-- 
2.7.4

