Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E59CFA4F1
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728986AbfKMBzC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:55:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfKMBzC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01DFA204EC;
        Wed, 13 Nov 2019 01:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610101;
        bh=oucbaIwMQWF2MuPnamtCAdOmq+gx0EtrQoYGxAWcjzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XXniWUelPEApte45GoiVyDAn3SggPhXUO4Z5kwxehzpU7Gkm2qfB7Vu73pNEBqmL4
         BD/o4NjZWOgeSNP9m9DwX+zIyAe/JPfmoKOkgUhQWP0exPrfhyGZ59FH/YPtS5bb/4
         1RLC7Jjv3Isblackm1ZEuhVUF/UtGYN9VXfWc6WA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh R <vigneshr@ti.com>, Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 161/209] mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capable
Date:   Tue, 12 Nov 2019 20:49:37 -0500
Message-Id: <20191113015025.9685-161-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh R <vigneshr@ti.com>

[ Upstream commit c974ac771479327b5424f60d58845e31daddadea ]

If a child device like touchscreen is wakeup capable, then keep ADC
interface on, so that a touching resistive screen will generate wakeup
event to the system.

Signed-off-by: Vignesh R <vigneshr@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/ti_am335x_tscadc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/mfd/ti_am335x_tscadc.c b/drivers/mfd/ti_am335x_tscadc.c
index fe8d335a4d74d..4660ad90ef556 100644
--- a/drivers/mfd/ti_am335x_tscadc.c
+++ b/drivers/mfd/ti_am335x_tscadc.c
@@ -295,11 +295,24 @@ static int ti_tscadc_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int __maybe_unused ti_tscadc_can_wakeup(struct device *dev, void *data)
+{
+	return device_may_wakeup(dev);
+}
+
 static int __maybe_unused tscadc_suspend(struct device *dev)
 {
 	struct ti_tscadc_dev	*tscadc = dev_get_drvdata(dev);
 
 	regmap_write(tscadc->regmap, REG_SE, 0x00);
+	if (device_for_each_child(dev, NULL, ti_tscadc_can_wakeup)) {
+		u32 ctrl;
+
+		regmap_read(tscadc->regmap, REG_CTRL, &ctrl);
+		ctrl &= ~(CNTRLREG_POWERDOWN);
+		ctrl |= CNTRLREG_TSCSSENB;
+		regmap_write(tscadc->regmap, REG_CTRL, ctrl);
+	}
 	pm_runtime_put_sync(dev);
 
 	return 0;
-- 
2.20.1

