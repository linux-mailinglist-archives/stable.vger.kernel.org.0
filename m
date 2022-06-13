Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83EB2548731
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379022AbiFMNqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379030AbiFMNnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:43:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A583EAA2;
        Mon, 13 Jun 2022 04:31:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9C3EB80E59;
        Mon, 13 Jun 2022 11:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B1F9C34114;
        Mon, 13 Jun 2022 11:31:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119903;
        bh=JrehKXxrjTqXNr1N+Mf44vqAbfx7l/lInBmbYCGalfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfKsm7GjmoITbt2y1wPtC9U00NW8bZtQ1RMWPNObsMrzAHrwOlaU8VeIF4wCWhPlI
         V8BBDn1JX4t9zXb+RKP8qjzwjRieWu7NQYuThoZSgj/TeUqvEN+TCulgrYTbSH4P8R
         n/TMUaJDGuh40vae5YUetwhBgbHxtK5vj0mRIUs0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <nfraprado@collabora.com>, Qii Wang <qii.wang@mediatek.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 160/339] i2c: mediatek: Optimize master_xfer() and avoid circular locking
Date:   Mon, 13 Jun 2022 12:09:45 +0200
Message-Id: <20220613094931.537096381@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 8b4fc246c3fffde96835b2f6d5d0e2a56c70d8f9 ]

Especially (but not only) during probe, it may happen that multiple
devices are communicating via i2c (or multiple i2c busses) and
sometimes while others are probing asynchronously.
For example, a Cr50 TPM may be filling entropy (or userspace may be
reading random data) while the rt5682 (i2c) codec driver reads/sets
some registers, like while getting/setting a clock's rate, which
happens both during probe and during system operation.

In this driver, the mtk_i2c_transfer() function (which is the i2c
.master_xfer() callback) was granularly managing the clocks by
performing a clk_bulk_prepare_enable() to start them and its inverse.
This is not only creating possible circular locking dependencies in
the some cases (like former explanation), but it's also suboptimal,
as clk_core prepare/unprepare operations are using mutex locking,
which creates a bit of unwanted overhead (for example, i2c trackpads
will call master_xfer() every few milliseconds!).

With this commit, we avoid both the circular locking and additional
overhead by changing how we handle the clocks in this driver:
- Prepare the clocks during probe (and PM resume)
- Enable/disable clocks in mtk_i2c_transfer()
- Unprepare the clocks only for driver removal (and PM suspend)

For the sake of providing a full explanation: during probe, the
clocks are not only prepared but also enabled, as this is needed
for some hardware initialization but, after that, we are disabling
but not unpreparing them, leaving an expected state for the
aforementioned clock handling strategy.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index f651d3e124d6..bdecb78bfc26 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1177,7 +1177,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 	int left_num = num;
 	struct mtk_i2c *i2c = i2c_get_adapdata(adap);
 
-	ret = clk_bulk_prepare_enable(I2C_MT65XX_CLK_MAX, i2c->clocks);
+	ret = clk_bulk_enable(I2C_MT65XX_CLK_MAX, i2c->clocks);
 	if (ret)
 		return ret;
 
@@ -1231,7 +1231,7 @@ static int mtk_i2c_transfer(struct i2c_adapter *adap,
 	ret = num;
 
 err_exit:
-	clk_bulk_disable_unprepare(I2C_MT65XX_CLK_MAX, i2c->clocks);
+	clk_bulk_disable(I2C_MT65XX_CLK_MAX, i2c->clocks);
 	return ret;
 }
 
@@ -1412,7 +1412,7 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 	mtk_i2c_init_hw(i2c);
-	clk_bulk_disable_unprepare(I2C_MT65XX_CLK_MAX, i2c->clocks);
+	clk_bulk_disable(I2C_MT65XX_CLK_MAX, i2c->clocks);
 
 	ret = devm_request_irq(&pdev->dev, irq, mtk_i2c_irq,
 			       IRQF_NO_SUSPEND | IRQF_TRIGGER_NONE,
@@ -1439,6 +1439,8 @@ static int mtk_i2c_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&i2c->adap);
 
+	clk_bulk_unprepare(I2C_MT65XX_CLK_MAX, i2c->clocks);
+
 	return 0;
 }
 
@@ -1448,6 +1450,7 @@ static int mtk_i2c_suspend_noirq(struct device *dev)
 	struct mtk_i2c *i2c = dev_get_drvdata(dev);
 
 	i2c_mark_adapter_suspended(&i2c->adap);
+	clk_bulk_unprepare(I2C_MT65XX_CLK_MAX, i2c->clocks);
 
 	return 0;
 }
@@ -1465,7 +1468,7 @@ static int mtk_i2c_resume_noirq(struct device *dev)
 
 	mtk_i2c_init_hw(i2c);
 
-	clk_bulk_disable_unprepare(I2C_MT65XX_CLK_MAX, i2c->clocks);
+	clk_bulk_disable(I2C_MT65XX_CLK_MAX, i2c->clocks);
 
 	i2c_mark_adapter_resumed(&i2c->adap);
 
-- 
2.35.1



