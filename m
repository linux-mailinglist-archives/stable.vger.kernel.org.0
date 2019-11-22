Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3012A106E14
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbfKVLF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:33882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbfKVLF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:05:59 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5469D2084D;
        Fri, 22 Nov 2019 11:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420758;
        bh=oucbaIwMQWF2MuPnamtCAdOmq+gx0EtrQoYGxAWcjzg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOZbt6fPgtjbtwisLY9klmL8wAyQv4Kk46OejhkSvXASDnsxcMH2zm0u0IMD+JVGd
         BZrhka+aAI/ZYHLBTWXj8rlQWmOTgDY/Myhhq2cEG4LsKRCVHoqIJeq4VNnaqtuzHV
         VdTsVzrDGN8qQfzB7smM64GYXYRzVo5CGBC95lho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh R <vigneshr@ti.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 172/220] mfd: ti_am335x_tscadc: Keep ADC interface on if child is wakeup capable
Date:   Fri, 22 Nov 2019 11:28:57 +0100
Message-Id: <20191122100925.213032982@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



