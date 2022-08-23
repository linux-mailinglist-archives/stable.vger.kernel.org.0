Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4897959D5CE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240355AbiHWJF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243457AbiHWJFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:05:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C24844D7;
        Tue, 23 Aug 2022 01:29:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08F57B81C54;
        Tue, 23 Aug 2022 08:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534FBC433C1;
        Tue, 23 Aug 2022 08:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243291;
        bh=ZFjxRbiSTCcpDSWigsu2rT70OLmGRjEoFzUdbveCR54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tbAalBBabyavGiPT756JXSNRUjfTqMGER3tURX/vXoIL4PlJHOM455Kh/73AL5PQz
         vyP8W5/f8hVehYgUXMSXdU8SWXihIBBL+ghoSSj4U2KB0nr0GRNmwD6oYvzVdWxoQX
         /9Je85SS2wri6fjkYIPTwSO8NjxIzTS4dyJxsaNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 5.19 229/365] i2c: imx: Make sure to unregister adapter on remove()
Date:   Tue, 23 Aug 2022 10:02:10 +0200
Message-Id: <20220823080127.791052445@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -1572,9 +1572,7 @@ static int i2c_imx_remove(struct platfor
 	struct imx_i2c_struct *i2c_imx = platform_get_drvdata(pdev);
 	int irq, ret;
 
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret < 0)
-		return ret;
+	ret = pm_runtime_get_sync(&pdev->dev);
 
 	hrtimer_cancel(&i2c_imx->slave_timer);
 
@@ -1585,17 +1583,21 @@ static int i2c_imx_remove(struct platfor
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


