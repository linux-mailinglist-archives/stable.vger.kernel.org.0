Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11EA3496ED4
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 01:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbiAWAOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 19:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235727AbiAWANz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 19:13:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3C6C061749;
        Sat, 22 Jan 2022 16:13:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AF2060F2F;
        Sun, 23 Jan 2022 00:13:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BBAC004E1;
        Sun, 23 Jan 2022 00:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642896786;
        bh=nxtaYekpVBFkHlh4jI55ddbaFFhM89Sm46JH25MlHJ4=;
        h=From:To:Cc:Subject:Date:From;
        b=JOStWGvzVypZnOeITP4Q7u4fm7plP7HhAD12Ak7f8mLdehQ2blaDCZ6vyiqlC9aN4
         yYoDQaqfXK/0fe1WFdim7kpv1vUU1l9bYbj8Rjrc4jGfgbsk+X5DWAxvmegqHJJehv
         JOivSbjx1OjE82HK7mDQJWt6FYNAWlNoJWQ9SbiLd70X07ZUhBcNFM6qz7P3yB069z
         Nd0b9BEBm/EvOa+i/ZEjPX9g3s3aluUMWaTvG5xm6R1Z7L5MqppoY4VqEiH98kmwRz
         wPH0jLsJmFEp1mCGr7ZATUb/KJAXHS9SYgizjxBxrUKmdFXZi9udxPY7Nh9pUpXctr
         hRAlP4gFpfiGg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabien Dessenne <fabien.dessenne@foss.st.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, ohad@wizery.com,
        mcoquelin.stm32@gmail.com, alexandre.torgue@foss.st.com,
        linux-remoteproc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 1/9] hwspinlock: stm32: enable clock at probe
Date:   Sat, 22 Jan 2022 19:12:50 -0500
Message-Id: <20220123001258.2460594-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
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

