Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036FA30C4B2
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 17:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235779AbhBBP7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:39392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235251AbhBBPMW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C11ED64F78;
        Tue,  2 Feb 2021 15:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278406;
        bh=V1IKRSGnn4ywBLad9z5xEwHymTivz5c2ZXpmKsej1yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FktedkbpCx+GeSla3N6bJ6s2YH82o2XN7veCWj5BR3zQ782+/gaVRWZ9DAVyUXKFq
         4vJVx5up4rJVhmfDi8wdRg1qTukRKgE29HZnUd5DvL9Z6HtejE1Q1yorrvAht260yh
         y9kEuAozcnINhJVL+cS9u0Ekl8PFoDCkYfQkHDCSQzs0WVcLG1NBtpVv0fctPp7VVv
         cjeX0VtCiREmPwLhSru7KKoWOLhqtj7gwiqZmL4Nqd+W4QAgMwjfVFOm3noCQy/zRx
         26G0iTyRXfJehTvBgn8wIVlhnkaLIe3U4+9jXk/sG2KgcFWMrMIJx85BYEEGhSqEap
         oQIwUGOaXZMqw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qii Wang <qii.wang@mediatek.com>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 23/25] i2c: mediatek: Move suspend and resume handling to NOIRQ phase
Date:   Tue,  2 Feb 2021 10:06:13 -0500
Message-Id: <20210202150615.1864175-23-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qii Wang <qii.wang@mediatek.com>

[ Upstream commit de96c3943f591018727b862f51953c1b6c55bcc3 ]

Some i2c device driver indirectly uses I2C driver when it is now
being suspended. The i2c devices driver is suspended during the
NOIRQ phase and this cannot be changed due to other dependencies.
Therefore, we also need to move the suspend handling for the I2C
controller driver to the NOIRQ phase as well.

Signed-off-by: Qii Wang <qii.wang@mediatek.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mt65xx.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mt65xx.c b/drivers/i2c/busses/i2c-mt65xx.c
index 0818d3e507347..2ffd2f354d0ae 100644
--- a/drivers/i2c/busses/i2c-mt65xx.c
+++ b/drivers/i2c/busses/i2c-mt65xx.c
@@ -1275,7 +1275,8 @@ static int mtk_i2c_probe(struct platform_device *pdev)
 	mtk_i2c_clock_disable(i2c);
 
 	ret = devm_request_irq(&pdev->dev, irq, mtk_i2c_irq,
-			       IRQF_TRIGGER_NONE, I2C_DRV_NAME, i2c);
+			       IRQF_NO_SUSPEND | IRQF_TRIGGER_NONE,
+			       I2C_DRV_NAME, i2c);
 	if (ret < 0) {
 		dev_err(&pdev->dev,
 			"Request I2C IRQ %d fail\n", irq);
@@ -1302,7 +1303,16 @@ static int mtk_i2c_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
-static int mtk_i2c_resume(struct device *dev)
+static int mtk_i2c_suspend_noirq(struct device *dev)
+{
+	struct mtk_i2c *i2c = dev_get_drvdata(dev);
+
+	i2c_mark_adapter_suspended(&i2c->adap);
+
+	return 0;
+}
+
+static int mtk_i2c_resume_noirq(struct device *dev)
 {
 	int ret;
 	struct mtk_i2c *i2c = dev_get_drvdata(dev);
@@ -1317,12 +1327,15 @@ static int mtk_i2c_resume(struct device *dev)
 
 	mtk_i2c_clock_disable(i2c);
 
+	i2c_mark_adapter_resumed(&i2c->adap);
+
 	return 0;
 }
 #endif
 
 static const struct dev_pm_ops mtk_i2c_pm = {
-	SET_SYSTEM_SLEEP_PM_OPS(NULL, mtk_i2c_resume)
+	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(mtk_i2c_suspend_noirq,
+				      mtk_i2c_resume_noirq)
 };
 
 static struct platform_driver mtk_i2c_driver = {
-- 
2.27.0

