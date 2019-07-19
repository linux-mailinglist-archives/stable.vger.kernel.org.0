Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF3C6DFD4
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfGSEiA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:38:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbfGSD7f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 18 Jul 2019 23:59:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC1CE21897;
        Fri, 19 Jul 2019 03:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563508774;
        bh=rQu1fthOwE3GJJSjLt530Jq0TgMDWOzmND3gXPhaF7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vopHwHRnrjJaObKmLNTHAV+oTykLinlFdOEW5n6bWxJUWe77Ok1Hd1Eu8J87i1DlA
         N8XuLddUCJAzi6gttgkp7q8jZ0PxrK8RAF9QRWhfyWE3BOr/gwU746JEUaHE2NtR/J
         lmmlMYdctoOFxFXJPkuBOqWMh7F2iUZOCB0BYFCo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fabrice Gasnier <fabrice.gasnier@st.com>,
        Pierre-Yves MORDRET <pierre-yves.mordret@st.com>,
        Fabien Dessenne <fabien.dessenne@st.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Sasha Levin <sashal@kernel.org>, linux-i2c@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 083/171] i2c: stm32f7: fix the get_irq error cases
Date:   Thu, 18 Jul 2019 23:55:14 -0400
Message-Id: <20190719035643.14300-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719035643.14300-1-sashal@kernel.org>
References: <20190719035643.14300-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabrice Gasnier <fabrice.gasnier@st.com>

[ Upstream commit 79b4499524ed659fb76323efc30f3dc03967c88f ]

During probe, return the "get_irq" error value instead of -EINVAL which
allows the driver to be deferred probed if needed.
Fix also the case where of_irq_get() returns a negative value.
Note :
On failure of_irq_get() returns 0 or a negative value while
platform_get_irq() returns a negative value.

Fixes: aeb068c57214 ("i2c: i2c-stm32f7: add driver")
Reviewed-by: Pierre-Yves MORDRET <pierre-yves.mordret@st.com>
Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@st.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-stm32f7.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/i2c/busses/i2c-stm32f7.c b/drivers/i2c/busses/i2c-stm32f7.c
index 48337bef5b87..3d90c0bb049e 100644
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -25,7 +25,6 @@
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_address.h>
-#include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pinctrl/consumer.h>
@@ -1816,15 +1815,14 @@ static struct i2c_algorithm stm32f7_i2c_algo = {
 
 static int stm32f7_i2c_probe(struct platform_device *pdev)
 {
-	struct device_node *np = pdev->dev.of_node;
 	struct stm32f7_i2c_dev *i2c_dev;
 	const struct stm32f7_i2c_setup *setup;
 	struct resource *res;
-	u32 irq_error, irq_event, clk_rate, rise_time, fall_time;
+	u32 clk_rate, rise_time, fall_time;
 	struct i2c_adapter *adap;
 	struct reset_control *rst;
 	dma_addr_t phy_addr;
-	int ret;
+	int irq_error, irq_event, ret;
 
 	i2c_dev = devm_kzalloc(&pdev->dev, sizeof(*i2c_dev), GFP_KERNEL);
 	if (!i2c_dev)
@@ -1836,16 +1834,20 @@ static int stm32f7_i2c_probe(struct platform_device *pdev)
 		return PTR_ERR(i2c_dev->base);
 	phy_addr = (dma_addr_t)res->start;
 
-	irq_event = irq_of_parse_and_map(np, 0);
-	if (!irq_event) {
-		dev_err(&pdev->dev, "IRQ event missing or invalid\n");
-		return -EINVAL;
+	irq_event = platform_get_irq(pdev, 0);
+	if (irq_event <= 0) {
+		if (irq_event != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get IRQ event: %d\n",
+				irq_event);
+		return irq_event ? : -ENOENT;
 	}
 
-	irq_error = irq_of_parse_and_map(np, 1);
-	if (!irq_error) {
-		dev_err(&pdev->dev, "IRQ error missing or invalid\n");
-		return -EINVAL;
+	irq_error = platform_get_irq(pdev, 1);
+	if (irq_error <= 0) {
+		if (irq_error != -EPROBE_DEFER)
+			dev_err(&pdev->dev, "Failed to get IRQ error: %d\n",
+				irq_error);
+		return irq_error ? : -ENOENT;
 	}
 
 	i2c_dev->clk = devm_clk_get(&pdev->dev, NULL);
-- 
2.20.1

