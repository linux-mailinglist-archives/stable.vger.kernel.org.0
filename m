Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBD72BA7F5
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:05:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727755AbgKTLDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:03:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbgKTLDn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:03:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61D6C206E3;
        Fri, 20 Nov 2020 11:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870222;
        bh=IZ0REELh59ErJlj0S+cGz1HpHl4qQmh1wNT9385bgqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K1ABcBpX4KXFYDeNRWcM77KPomvAZNMs5p5LVPHw5rpZEHdxT4rwJlw+j220TL58F
         uRYCqQzyQQXqYotbsxMewR+MoIxyMZjPRuoKS8oDTtcYJsZRWFKG0tRolcMAF/PvG7
         nMR//hEAphVv6aDvDdf8aEQFTDX+6CDr9j/XZbhg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 09/15] i2c: imx: Fix external abort on interrupt in exit paths
Date:   Fri, 20 Nov 2020 12:03:07 +0100
Message-Id: <20201120104540.013340822@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104539.534424264@linuxfoundation.org>
References: <20201120104539.534424264@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit e50e4f0b85be308a01b830c5fbdffc657e1a6dd0 upstream

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
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
[sudip: manual backport with extra label for goto]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1093,20 +1093,20 @@ static int i2c_imx_probe(struct platform
 		goto clk_disable;
 	}
 
-	/* Request IRQ */
-	ret = devm_request_irq(&pdev->dev, irq, i2c_imx_isr, 0,
-				pdev->name, i2c_imx);
-	if (ret) {
-		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
-		goto clk_disable;
-	}
-
 	/* Init queue */
 	init_waitqueue_head(&i2c_imx->queue);
 
 	/* Set up adapter data */
 	i2c_set_adapdata(&i2c_imx->adapter, i2c_imx);
 
+	/* Request IRQ */
+	ret = request_threaded_irq(irq, i2c_imx_isr, NULL, 0,
+				   pdev->name, i2c_imx);
+	if (ret) {
+		dev_err(&pdev->dev, "can't claim irq %d\n", irq);
+		goto clk_disable;
+	}
+
 	/* Set up clock divider */
 	i2c_imx->bitrate = IMX_I2C_BIT_RATE;
 	ret = of_property_read_u32(pdev->dev.of_node,
@@ -1125,7 +1125,7 @@ static int i2c_imx_probe(struct platform
 	ret = i2c_add_numbered_adapter(&i2c_imx->adapter);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "registration failed\n");
-		goto clk_disable;
+		goto clk_free_irq;
 	}
 
 	/* Set up platform driver data */
@@ -1143,6 +1143,8 @@ static int i2c_imx_probe(struct platform
 
 	return 0;   /* Return OK */
 
+clk_free_irq:
+	free_irq(irq, i2c_imx);
 clk_disable:
 	clk_disable_unprepare(i2c_imx->clk);
 	return ret;
@@ -1151,6 +1153,7 @@ clk_disable:
 static int i2c_imx_remove(struct platform_device *pdev)
 {
 	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
+	int irq;
 
 	/* remove adapter */
 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
@@ -1165,6 +1168,10 @@ static int i2c_imx_remove(struct platfor
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2CR);
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
 
+	irq = platform_get_irq(pdev, 0);
+	if (irq >= 0)
+		free_irq(irq, i2c_imx);
+
 	return 0;
 }
 


