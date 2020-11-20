Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B45962BA8BA
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgKTLKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:10:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbgKTLFk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:05:40 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ACA22222F;
        Fri, 20 Nov 2020 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870339;
        bh=uZP5PO/o0bTiMJkMMZ9aGNNs5w+4eUQLtZYBwDLUAVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hHhi0Gv1zhg/GunVJ2jedDigsufF8vjaf7q+HCN5uBD5HbL+cyVZn/sh9U/SAb7S
         0mG3Qo5JN3jK7UELh5mpUdg9mvcQw6p9WB70sETdFsJNI2EKIKh3YHNgtlqe75ciW/
         MtFjJxNPEtXpkMS2XdeKIOTNhUJPLcu773gL7SeQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 09/17] i2c: imx: use clk notifier for rate changes
Date:   Fri, 20 Nov 2020 12:03:20 +0100
Message-Id: <20201120104540.879118968@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104540.414709708@linuxfoundation.org>
References: <20201120104540.414709708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

commit 90ad2cbe88c22d0215225ab9594eeead0eb24fde upstream

Instead of repeatedly calling clk_get_rate for each transfer, register
a clock notifier to update the cached divider value each time the clock
rate actually changes.

Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |   32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -194,6 +194,7 @@ struct imx_i2c_dma {
 struct imx_i2c_struct {
 	struct i2c_adapter	adapter;
 	struct clk		*clk;
+	struct notifier_block	clk_change_nb;
 	void __iomem		*base;
 	wait_queue_head_t	queue;
 	unsigned long		i2csr;
@@ -468,15 +469,14 @@ static int i2c_imx_acked(struct imx_i2c_
 	return 0;
 }
 
-static void i2c_imx_set_clk(struct imx_i2c_struct *i2c_imx)
+static void i2c_imx_set_clk(struct imx_i2c_struct *i2c_imx,
+			    unsigned int i2c_clk_rate)
 {
 	struct imx_i2c_clk_pair *i2c_clk_div = i2c_imx->hwdata->clk_div;
-	unsigned int i2c_clk_rate;
 	unsigned int div;
 	int i;
 
 	/* Divider value calculation */
-	i2c_clk_rate = clk_get_rate(i2c_imx->clk);
 	if (i2c_imx->cur_clk == i2c_clk_rate)
 		return;
 
@@ -511,6 +511,20 @@ static void i2c_imx_set_clk(struct imx_i
 #endif
 }
 
+static int i2c_imx_clk_notifier_call(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct clk_notifier_data *ndata = data;
+	struct imx_i2c_struct *i2c_imx = container_of(&ndata->clk,
+						      struct imx_i2c_struct,
+						      clk);
+
+	if (action & POST_RATE_CHANGE)
+		i2c_imx_set_clk(i2c_imx, ndata->new_rate);
+
+	return NOTIFY_OK;
+}
+
 static int i2c_imx_start(struct imx_i2c_struct *i2c_imx)
 {
 	unsigned int temp = 0;
@@ -518,8 +532,6 @@ static int i2c_imx_start(struct imx_i2c_
 
 	dev_dbg(&i2c_imx->adapter.dev, "<%s>\n", __func__);
 
-	i2c_imx_set_clk(i2c_imx);
-
 	imx_i2c_write_reg(i2c_imx->ifdr, i2c_imx, IMX_I2C_IFDR);
 	/* Enable I2C controller */
 	imx_i2c_write_reg(i2c_imx->hwdata->i2sr_clr_opcode, i2c_imx, IMX_I2C_I2SR);
@@ -1131,6 +1143,9 @@ static int i2c_imx_probe(struct platform
 				   "clock-frequency", &i2c_imx->bitrate);
 	if (ret < 0 && pdata && pdata->bitrate)
 		i2c_imx->bitrate = pdata->bitrate;
+	i2c_imx->clk_change_nb.notifier_call = i2c_imx_clk_notifier_call;
+	clk_notifier_register(i2c_imx->clk, &i2c_imx->clk_change_nb);
+	i2c_imx_set_clk(i2c_imx, clk_get_rate(i2c_imx->clk));
 
 	/* Set up chip registers to defaults */
 	imx_i2c_write_reg(i2c_imx->hwdata->i2cr_ien_opcode ^ I2CR_IEN,
@@ -1141,12 +1156,12 @@ static int i2c_imx_probe(struct platform
 	ret = i2c_imx_init_recovery_info(i2c_imx, pdev);
 	/* Give it another chance if pinctrl used is not ready yet */
 	if (ret == -EPROBE_DEFER)
-		goto rpm_disable;
+		goto clk_notifier_unregister;
 
 	/* Add I2C adapter */
 	ret = i2c_add_numbered_adapter(&i2c_imx->adapter);
 	if (ret < 0)
-		goto rpm_disable;
+		goto clk_notifier_unregister;
 
 	pm_runtime_mark_last_busy(&pdev->dev);
 	pm_runtime_put_autosuspend(&pdev->dev);
@@ -1162,6 +1177,8 @@ static int i2c_imx_probe(struct platform
 
 	return 0;   /* Return OK */
 
+clk_notifier_unregister:
+	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
 rpm_disable:
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
@@ -1195,6 +1212,7 @@ static int i2c_imx_remove(struct platfor
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2CR);
 	imx_i2c_write_reg(0, i2c_imx, IMX_I2C_I2SR);
 
+	clk_notifier_unregister(i2c_imx->clk, &i2c_imx->clk_change_nb);
 	clk_disable_unprepare(i2c_imx->clk);
 
 	pm_runtime_put_noidle(&pdev->dev);


