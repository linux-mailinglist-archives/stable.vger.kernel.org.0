Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9692F496E5A
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiAWALb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:11:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35534 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbiAWAL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:11:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A82960F77;
        Sun, 23 Jan 2022 00:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D3BC340E5;
        Sun, 23 Jan 2022 00:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896687;
        bh=nxtaYekpVBFkHlh4jI55ddbaFFhM89Sm46JH25MlHJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V394ZqO03cxC+V6r9cmbyVU5WeUDpap0fsz07+z+WOwDLubefISwXUVzpB6bj55XH
         6y/J4HNdzukzOjO99Gf+iRlHXbBWKmSD3kpQBmSb+96jodue0h6u6bJ4h7OSp3zcDk
         ANi6zA6T6rf6RPu8R4CLG6C5Qk4EUMx4mzjxtlmiNhkIaAfKrX+fX4jnUjZ+3dNJsA
         UP/INCyQTjGxHCN5wuZXC817ZH7Hic9kg17AS48Jmd2hZKFSOYufZnqZ38NNh4o3F6
         8xyCLzIR3tK6HUXHLUs+JWgNQuSCDbQRP5ML+5wO+RR30c7ap6Xtz9qggaulApO8kq
         +RI6n/1NW5E4A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, ohad@wizery.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        linux-remoteproc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.16 02/19] hwspinlock: stm32: enable clock at probe
Date:   Sat, 22 Jan 2022 19:10:55 -0500
Message-Id: <20220123001113.2460140-2-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220123001113.2460140-1-sashal@kernel.org>
References: <20220123001113.2460140-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabien Dessenne <fabien.dessenne@foss.st.com>

[ Upstream commit 60630924bb5af8751adcecc896e7763c3783ca89 ]

Set the clock during probe and keep its control during suspend / resume
operations.
This fixes an issue when CONFIG_PM is not set and where the clock is
never enabled.

Make use of devm_ functions to simplify the code.

Signed-off-by: Fabien Dessenne <fabien.dessenne@foss.st.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211011135836.1045437-1-fabien.dessenne@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwspinlock/stm32_hwspinlock.c | 58 +++++++++++++++++----------
 1 file changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/hwspinlock/stm32_hwspinlock.c b/drivers/hwspinlock/stm32_hwspinlock.c
index 3ad0ce0da4d98..5bd11a7fab65d 100644
--- a/drivers/hwspinlock/stm32_hwspinlock.c
+++ b/drivers/hwspinlock/stm32_hwspinlock.c
@@ -54,8 +54,23 @@ static const struct hwspinlock_ops stm32_hwspinlock_ops = {
 	.relax		= stm32_hwspinlock_relax,
 };
 
+static void stm32_hwspinlock_disable_clk(void *data)
+{
+	struct platform_device *pdev = data;
+	struct stm32_hwspinlock *hw = platform_get_drvdata(pdev);
+	struct device *dev = &pdev->dev;
+
+	pm_runtime_get_sync(dev);
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
+	pm_runtime_put_noidle(dev);
+
+	clk_disable_unprepare(hw->clk);
+}
+
 static int stm32_hwspinlock_probe(struct platform_device *pdev)
 {
+	struct device *dev = &pdev->dev;
 	struct stm32_hwspinlock *hw;
 	void __iomem *io_base;
 	size_t array_size;
@@ -66,41 +81,43 @@ static int stm32_hwspinlock_probe(struct platform_device *pdev)
 		return PTR_ERR(io_base);
 
 	array_size = STM32_MUTEX_NUM_LOCKS * sizeof(struct hwspinlock);
-	hw = devm_kzalloc(&pdev->dev, sizeof(*hw) + array_size, GFP_KERNEL);
+	hw = devm_kzalloc(dev, sizeof(*hw) + array_size, GFP_KERNEL);
 	if (!hw)
 		return -ENOMEM;
 
-	hw->clk = devm_clk_get(&pdev->dev, "hsem");
+	hw->clk = devm_clk_get(dev, "hsem");
 	if (IS_ERR(hw->clk))
 		return PTR_ERR(hw->clk);
 
-	for (i = 0; i < STM32_MUTEX_NUM_LOCKS; i++)
-		hw->bank.lock[i].priv = io_base + i * sizeof(u32);
+	ret = clk_prepare_enable(hw->clk);
+	if (ret) {
+		dev_err(dev, "Failed to prepare_enable clock\n");
+		return ret;
+	}
 
 	platform_set_drvdata(pdev, hw);
-	pm_runtime_enable(&pdev->dev);
 
-	ret = hwspin_lock_register(&hw->bank, &pdev->dev, &stm32_hwspinlock_ops,
-				   0, STM32_MUTEX_NUM_LOCKS);
+	pm_runtime_get_noresume(dev);
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+	pm_runtime_put(dev);
 
-	if (ret)
-		pm_runtime_disable(&pdev->dev);
+	ret = devm_add_action_or_reset(dev, stm32_hwspinlock_disable_clk, pdev);
+	if (ret) {
+		dev_err(dev, "Failed to register action\n");
+		return ret;
+	}
 
-	return ret;
-}
+	for (i = 0; i < STM32_MUTEX_NUM_LOCKS; i++)
+		hw->bank.lock[i].priv = io_base + i * sizeof(u32);
 
-static int stm32_hwspinlock_remove(struct platform_device *pdev)
-{
-	struct stm32_hwspinlock *hw = platform_get_drvdata(pdev);
-	int ret;
+	ret = devm_hwspin_lock_register(dev, &hw->bank, &stm32_hwspinlock_ops,
+					0, STM32_MUTEX_NUM_LOCKS);
 
-	ret = hwspin_lock_unregister(&hw->bank);
 	if (ret)
-		dev_err(&pdev->dev, "%s failed: %d\n", __func__, ret);
-
-	pm_runtime_disable(&pdev->dev);
+		dev_err(dev, "Failed to register hwspinlock\n");
 
-	return 0;
+	return ret;
 }
 
 static int __maybe_unused stm32_hwspinlock_runtime_suspend(struct device *dev)
@@ -135,7 +152,6 @@ MODULE_DEVICE_TABLE(of, stm32_hwpinlock_ids);
 
 static struct platform_driver stm32_hwspinlock_driver = {
 	.probe		= stm32_hwspinlock_probe,
-	.remove		= stm32_hwspinlock_remove,
 	.driver		= {
 		.name	= "stm32_hwspinlock",
 		.of_match_table = stm32_hwpinlock_ids,
-- 
2.34.1

