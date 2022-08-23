Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D915659E342
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350430AbiHWMSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356514AbiHWMPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:15:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC28098D22;
        Tue, 23 Aug 2022 02:41:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B867D614C7;
        Tue, 23 Aug 2022 09:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3253C433D6;
        Tue, 23 Aug 2022 09:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247604;
        bh=8abBVobj0M1tTJjPmNRvhvxyiACx1wxIn8CgGIfsnbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e/Oa2s4sB+dNEtV21l/aoHlcsjY7IuAAbT6Rta8V2crjJlyq+GzlB+/r0fgtqjm8X
         EtoEBrKNOiWBDpfo7HEIA6A34IHwD6STjMsnQxB5KTLZZaa1CFNG4pJz65CcSNxC61
         ooz0RI6++ba/8qmQkf+Xhdmn6y0WOxfx/CsJaJ9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.10 087/158] i2c: imx: Make sure to unregister adapter on remove()
Date:   Tue, 23 Aug 2022 10:26:59 +0200
Message-Id: <20220823080049.573801282@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

commit d98bdd3a5b50446d8e010be5b04ce81c4eabf728 upstream.

If for whatever reasons pm_runtime_resume_and_get() fails and .remove() is
exited early, the i2c adapter stays around and the irq still calls its
handler, while the driver data and the register mapping go away. So if
later the i2c adapter is accessed or the irq triggers this results in
havoc accessing freed memory and unmapped registers.

So unregister the software resources even if resume failed, and only skip
the hardware access in that case.

Fixes: 588eb93ea49f ("i2c: imx: add runtime pm support to improve the performance")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1280,9 +1280,7 @@ static int i2c_imx_remove(struct platfor
 	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
 	int irq, ret;
 
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret < 0)
-		return ret;
+	ret = pm_runtime_get_sync(&pdev->dev);
 
 	/* remove adapter */
 	dev_dbg(&i2c_imx->adapter.dev, "adapter removed\n");
@@ -1291,17 +1289,21 @@ static int i2c_imx_remove(struct platfor
 	if (i2c_imx->dma)
 		i2c_imx_dma_free(i2c_imx);
 
-	/* setup chip registers to defaults */
-	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
-	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
-	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2CR);
-	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
+	if (ret == 0) {
+		/* setup chip registers to defaults */
+		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
+		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
+		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2CR);
+		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
+		clk_disable(i2c_imx->clk);
+	}
 
 	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
 	irq = platform_get_irq(pdev, 0);
 	if (irq >= 0)
 		free_irq(irq, i2c_imx);
-	clk_disable_unprepare(i2c_imx->clk);
+
+	clk_unprepare(i2c_imx->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);


